import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)
drop.preparations.append(Document.self)
drop.preparations.append(Course.self)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("documents/add", Course.self) { request, course in
    return try drop.view.make("Document/add.leaf", ["course": course])
}

drop.resource("courses", CourseController())
drop.resource("documents", DocumentController())

drop.run()
