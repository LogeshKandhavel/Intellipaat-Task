import Foundation

public protocol CourseLocalDataSourceProtocol: Sendable {
    func saveCourses(_ courses: [Course]) throws
    func getCachedCourses() throws -> [Course]
    func saveLessons(_ lessons: [Lesson], for courseId: Int) throws
    func getCachedLessons(for courseId: Int) throws -> [Lesson]
    func clearCache() throws
}

public final class CourseLocalDataSource: CourseLocalDataSourceProtocol {
    private let storage: LocalStorage
    private let coursesKey = "cached_courses_list"
    private let lessonsKeyPrefix = "cached_lessons_course_"
    
    public init(storage: LocalStorage = .shared) {
        self.storage = storage
    }
    
    public func saveCourses(_ courses: [Course]) throws {
        try storage.save(courses, forKey: coursesKey)
    }
    
    public func getCachedCourses() throws -> [Course] {
        return try storage.load(forKey: coursesKey, as: [Course].self)
    }
    
    public func saveLessons(_ lessons: [Lesson], for courseId: Int) throws {
        try storage.save(lessons, forKey: "\(lessonsKeyPrefix)\(courseId)")
    }
    
    public func getCachedLessons(for courseId: Int) throws -> [Lesson] {
        return try storage.load(forKey: "\(lessonsKeyPrefix)\(courseId)", as: [Lesson].self)
    }
    
    public func clearCache() throws {
        storage.clearAll()
    }
}
