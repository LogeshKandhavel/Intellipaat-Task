import Foundation

public final class MockRemoteDataSource: CourseRemoteDataSourceProtocol, @unchecked Sendable {
    public static let shared = MockRemoteDataSource()
    
    private let lock = NSLock()
    private var _isSimulatingOffline: Bool = false
    private var _isSimulatingEmpty: Bool = false
    private var _isSimulatingError: Bool = false
    
    public var isSimulatingOffline: Bool {
        get { lock.withLock { _isSimulatingOffline } }
        set { lock.withLock { _isSimulatingOffline = newValue } }
    }
    
    public var isSimulatingEmpty: Bool {
        get { lock.withLock { _isSimulatingEmpty } }
        set { lock.withLock { _isSimulatingEmpty = newValue } }
    }
    
    public var isSimulatingError: Bool {
        get { lock.withLock { _isSimulatingError } }
        set { lock.withLock { _isSimulatingError = newValue } }
    }
    
    private let defaultCourses: [Course] = [
        Course(id: 1, title: "Python Programming", instructor: "John Smith", progress: 50, lessons: 4),
        Course(id: 2, title: "Generative AI", instructor: "Sarah Williams", progress: 40, lessons: 16),
        Course(id: 3, title: "Full Stack Development", instructor: "David Brown", progress: 25, lessons: 28)
    ]
    
    public init() {}
    
    public func fetchCourses() async throws -> [Course] {
        // Artificial network delay
        try await Task.sleep(nanoseconds: 600_000_000)
        
        if isSimulatingOffline || isSimulatingError {
            throw NetworkError.networkUnavailable
        }
        
        if isSimulatingEmpty {
            return []
        }
        
        // Attempt to load from bundled courses.json if available
        if let url = Bundle.main.url(forResource: "courses", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Course].self, from: data) {
            return decoded
        }
        
        return defaultCourses
    }
    
    public func fetchLessons(for courseId: Int) async throws -> [Lesson] {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        if isSimulatingOffline || isSimulatingError {
            throw NetworkError.networkUnavailable
        }
        
        switch courseId {
        case 1:
            // Python Programming default demo lessons
            return [
                Lesson(id: 101, courseId: 1, title: "Introduction", isCompleted: true),
                Lesson(id: 102, courseId: 1, title: "Variables & Data Types", isCompleted: true),
                Lesson(id: 103, courseId: 1, title: "Functions", isCompleted: false),
                Lesson(id: 104, courseId: 1, title: "OOP", isCompleted: false)
            ]
        case 2:
            // Generative AI
            return [
                Lesson(id: 201, courseId: 2, title: "Introduction to GenAI", isCompleted: true),
                Lesson(id: 202, courseId: 2, title: "Prompt Engineering", isCompleted: true),
                Lesson(id: 203, courseId: 2, title: "Embeddings & Vector Databases", isCompleted: false),
                Lesson(id: 204, courseId: 2, title: "Fine-Tuning Models", isCompleted: false),
                Lesson(id: 205, courseId: 2, title: "RAG Architecture", isCompleted: false)
            ]
        case 3:
            // Full Stack Development
            return [
                Lesson(id: 301, courseId: 3, title: "Frontend Fundamentals", isCompleted: true),
                Lesson(id: 302, courseId: 3, title: "RESTful APIs & Backend", isCompleted: false),
                Lesson(id: 303, courseId: 3, title: "Database Design & SQL", isCompleted: false),
                Lesson(id: 304, courseId: 3, title: "Deployment & CI/CD", isCompleted: false)
            ]
        default:
            return [
                Lesson(id: 901, courseId: courseId, title: "Course Overview", isCompleted: false),
                Lesson(id: 902, courseId: courseId, title: "Core Concepts", isCompleted: false),
                Lesson(id: 903, courseId: courseId, title: "Hands-on Practice", isCompleted: false)
            ]
        }
    }
}
