import Vapor
import Fluent

import Foundation

extension Multipart.File {
    
    enum Error: Swift.Error {
        case notStored
    }
    func store(atPath: String) throws {
        
        let manager = FileManager.default
        let storable = Data(bytes: data)
        
        guard manager.createFile(atPath: "somepath", contents: storable, attributes: nil) else {
            throw Error.notStored
        }
    }
}
