import Vapor
import HTTP

final class DocumentController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        let courses = try Course.all().map { try $0.format() }
        return try drop.view.make("courses.leaf", ["courses": courses.makeNode()])
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todo = try Document(request: request)
        try todo.save()
        return todo
    }
    
    func show(request: Request, document: Document) throws -> ResponseRepresentable {
        return document
    }
    
    func makeResource() -> Resource<Document> {
        return Resource(
            index: index,
            store: create,
            show: show
        )
    }
}

extension Document {
    public convenience init(request: Request) throws {
        guard let name = request.data["name"]?.string else {
            throw Abort.badRequest
        }
        
        guard let file = request.multipart?["file"]?.file else {
            throw Abort.custom(status: .badRequest, message: "No file uploaded")
        }
        
        guard let id = request.data["courseId"]?.int, let course = try Course.find(id) else {
            throw Abort.custom(status: .badRequest, message: "No corresponding course found")
        }
                
        try self.init(name: name, file: file, course: course)
        
    }
}
