import Foundation

public struct Lesson: Identifiable, Codable, Equatable, Hashable {
    public let id: Int
    public let courseId: Int
    public var title: String
    public var isCompleted: Bool
    
    public init(id: Int, courseId: Int, title: String, isCompleted: Bool = false) {
        self.id = id
        self.courseId = courseId
        self.title = title
        self.isCompleted = isCompleted
    }
}
