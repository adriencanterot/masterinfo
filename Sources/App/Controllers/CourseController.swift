import Vapor
import HTTP

import Foundation

final class CourseController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        let courses = try Course.all().map { try $0.format() }
        return try drop.view.make("courses.leaf", ["courses": courses.makeNode()])
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todo = try Course(content: request.data)
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
        var new = try Course(content: request.data)
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

