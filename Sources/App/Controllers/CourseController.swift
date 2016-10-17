import Vapor
import HTTP

import Foundation

final class CourseController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        let courses = try Course.all().map { try $0.format() }
        return try drop.view.make("courses.leaf", ["courses": courses.makeNode()])
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todo = try Course(with: request)
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
        var new = try Course(with: request)
        new.id = course.id
        try new.save()
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

extension Course {
    public convenience init(with request: Request) throws {
        guard let name = request.data["name"]?.string,
              let timestamp = request.data["date"]?.double else {
            throw Abort.badRequest
        }
        
        let date = Date(timeIntervalSince1970: timestamp)
        self.init(name: name, date: date)
    }
}

