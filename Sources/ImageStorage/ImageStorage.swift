import Foundation

public struct ImageStorage : Sendable {
    let imagesFolderName = "images"
    let fileExtension = ".png"
    
    public init() {}
    
    public func save(_ id: UUID, _ data: Data) throws {
        try saveInternal(id, data, inFolder: imagesFolderName)
    }
    
    public func get(_ id: UUID) -> Data {
        return getInternal(id, inFolder: imagesFolderName)
    }
    
    func getInternal(_ id: UUID, inFolder folderName: String) -> Data {
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let folderURL = documentsDirectory.appendingPathComponent(folderName)
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                let filename = id.uuidString + fileExtension
                let fileURL = folderURL.appendingPathComponent(filename)
                
                let data = try Data(contentsOf: fileURL)
                
                return data
            }
            catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        return Data()
    }
    
    func saveInternal(_ id: UUID, _ data: Data, inFolder folderName: String) throws {
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let filename = id.uuidString + fileExtension
            let fileURL = folderURL.appendingPathComponent(filename)
            try data.write(to: fileURL)
        }
    }
    
    public func getPath(_ id: UUID) -> String {
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent(imagesFolderName)
            let filename = id.uuidString + fileExtension
            let fileURL = folderURL.appendingPathComponent(filename)
            
            return fileURL.absoluteString
        }
        
        return ""
    }
    
    public func remove(_ id: UUID) throws {
        try removeInternal(id, fromFolder: imagesFolderName)
    }
    
    func removeInternal(_ id: UUID, fromFolder folderName: String) throws {
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            let filename = id.uuidString + fileExtension
            let fileURL = folderURL.appendingPathComponent(filename)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
        }
    }
}
