import Vapor
import Fluent

final class File {
    var path:String
    
    public init(path:String) {
        self.path = path
    }
}
