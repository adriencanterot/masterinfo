import Vapor
import HTTP

final class CoursesController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Course.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todo = try request.course()
        try todo.save()
        return todo
    }
    
    func show(request: Request, course: Course) throws -> ResponseRepresentable {
        return course
    }
    
    func delete(request: Request, course: Course) throws -> ResponseRepresentable {
        try course.delete()
        return JSON([:])
    }
    
    
    func update(request: Request, course: Course) throws -> ResponseRepresentable {
        let new = try request.course()
        var course = course
        course.name = new.name
        try course.save()
        return course
    }
    
    
    func makeResource() -> Resource<Course> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}

extension Request {
    func course() throws -> Course {
        guard let json = json else { throw Abort.badRequest }
        return try Course(node: json)
    }
}
