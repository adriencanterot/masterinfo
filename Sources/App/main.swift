import Vapor
import VaporSQLite

let drop = Droplet()

let workDir = drop.workDir

try drop.addProvider(VaporSQLite.Provider.self)
drop.preparations.append(Document.self)
drop.preparations.append(Course.self)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("documents/add", Course.self) { request, course in
    try drop.view.make("Document/add.leaf", ["course" : course])
}

drop.resource("documents", DocumentController())
drop.resource("courses", CourseController())

drop.run()
