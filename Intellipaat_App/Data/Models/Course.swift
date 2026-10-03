import Foundation

public struct Course: Identifiable, Codable, Equatable, Hashable {
    public let id: Int
    public var title: String
    public var instructor: String
    public var progress: Int
    public var lessons: Int
    
    public init(id: Int, title: String, instructor: String, progress: Int, lessons: Int) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessons = lessons
    }
}
