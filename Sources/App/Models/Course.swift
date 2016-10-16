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
    
    public convenience init(content: Content) throws {
        guard let name = content["name"]?.string,
            let date = content["date"]?.double else {
                
                throw Abort.badRequest
        }
        
        self.init(name: name, date: Date(timeIntervalSince1970: date))
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "date": date.timeIntervalSince1970.makeNode()
            ])
    }
    
    func format() throws -> Node {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return try Node(node: [
            "id": id,
            "name": name,
            "date": formatter.string(from: date)
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
