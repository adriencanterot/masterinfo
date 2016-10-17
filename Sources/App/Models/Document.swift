import Vapor
import Fluent
import Foundation

final class Document: Model {


    var id: Node?
    var courseId: Node?
    var name: String
    var file: Multipart.File?
    var path: String
    
    public init(name: String, path: String, course:Course) {
        self.name = name
        self.path = path
        
        self.courseId = course.id
    }
    
    public init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        courseId = try node.extract("course_id")
        name = try node.extract("name")
        path = try node.extract("path")
    }
    
    public convenience init(name: String, file: Multipart.File, course: Course) throws {
        
        let endName = UUID().uuidString + "-" + file.name!
        let path = workDir + "Public/documents/" + endName
        try file.store(atPath: path)
        self.init(name: name, path: "documents/" + endName, course: course)
    }
    
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "course_id": courseId,
            "name": name,
            "path": path
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(entity) { course in
            course.id()
            course.parent(Course.self)
            course.string("name")
            course.string("path")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(entity)
    }
    
}

extension Document {
    func course() throws -> Course? {
        return try parent(courseId).get()
    }
}
