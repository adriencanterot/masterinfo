import Vapor
import Fluent
import Foundation

final class Course: Model {
    var id:Node?
    var name:String
    var date:Date
    
    public init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    public init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        let timestamp: Double = try node.extract("date")
        date = Date(timeIntervalSince1970: timestamp)
    }
    
    func format() throws -> Node {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yymmdd"
        
        return try Node(node: [
            "id": id,
            "name": name,
            "date": dateFormatter.string(from: date),
            "documents": try documents().all().makeNode()
            ])
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "date": date.timeIntervalSince1970.makeNode()
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(entity) { course in
            course.id()
            course.string("name")
            course.double("date")
        }
    }
        
    static func revert(_ database: Database) throws {
        try database.delete(entity)
    }
    
}

extension Course {
    func documents() -> Children<Document> {
        return children()
    }
}
