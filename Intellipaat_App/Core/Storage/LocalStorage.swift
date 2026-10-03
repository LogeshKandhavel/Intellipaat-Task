import Foundation

/// Lightweight, reliable, file-backed local cache storage.
public final class LocalStorage: Sendable {
    public static let shared = LocalStorage()
    
    private let fileManager = FileManager.default
    private let baseDirectory: URL
    
    public init(directoryName: String = "IntellipaatAppStorage") {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storageDir = appSupport.appendingPathComponent(directoryName, isDirectory: true)
        
        if !fileManager.fileExists(atPath: storageDir.path) {
            try? fileManager.createDirectory(at: storageDir, withIntermediateDirectories: true, attributes: nil)
        }
        self.baseDirectory = storageDir
    }
    
    public func save<T: Encodable>(_ object: T, forKey key: String) throws {
        let fileURL = baseDirectory.appendingPathComponent("\(key).json")
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL, options: .atomic)
    }
    
    public func load<T: Decodable>(forKey key: String, as type: T.Type) throws -> T {
        let fileURL = baseDirectory.appendingPathComponent("\(key).json")
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw NetworkError.noCachedData
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func remove(forKey key: String) {
        let fileURL = baseDirectory.appendingPathComponent("\(key).json")
        try? fileManager.removeItem(at: fileURL)
    }
    
    public func clearAll() {
        try? fileManager.removeItem(at: baseDirectory)
        try? fileManager.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}
