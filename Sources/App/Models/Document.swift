import Vapor
import Fluent
import Foundation

final class Document: Model {


    var id:Node?
    var name:String
    var file:File
    
    var courseId: Node?
    
    public init(name: String, file: File, course:Course) {
        self.name = name
        self.file = file
        self.courseId = course.id
    }
    
    public init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        courseId = try node.extract("course_id")
        name = try node.extract("name")
        let path: String = try node.extract("file")
        file = File(path: path)
    }
    
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "course": try course()?.makeNode(),
            "name": name,
            "file": file.path
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(entity) { course in
            course.id()
            course.parent(Course.self)
            course.string("name")
            course.string("file")
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
