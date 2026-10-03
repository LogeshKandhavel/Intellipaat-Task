import Foundation

public protocol CourseRepositoryProtocol: Sendable {
    var remoteDataSource: CourseRemoteDataSourceProtocol { get }
    var localDataSource: CourseLocalDataSourceProtocol { get }
    
    func getCourses() async throws -> [Course]
    func getLessons(for courseId: Int) async throws -> [Lesson]
    func toggleLessonCompletion(courseId: Int, lessonId: Int) async throws -> (lessons: [Lesson], newProgress: Int)
}

public final class CourseRepository: CourseRepositoryProtocol, @unchecked Sendable {
    public static let shared = CourseRepository()
    
    public let remoteDataSource: CourseRemoteDataSourceProtocol
    public let localDataSource: CourseLocalDataSourceProtocol
    
    public init(
        remoteDataSource: CourseRemoteDataSourceProtocol = MockRemoteDataSource.shared,
        localDataSource: CourseLocalDataSourceProtocol = CourseLocalDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getCourses() async throws -> [Course] {
        do {
            let remoteCourses = try await remoteDataSource.fetchCourses()
            // Save to local cache on success
            try? localDataSource.saveCourses(remoteCourses)
            return remoteCourses
        } catch {
            // Fallback: check local storage cache
            if let cached = try? localDataSource.getCachedCourses(), !cached.isEmpty {
                return cached
            }
            throw NetworkError.networkUnavailable
        }
    }
    
    public func getLessons(for courseId: Int) async throws -> [Lesson] {
        if let cached = try? localDataSource.getCachedLessons(for: courseId), !cached.isEmpty {
            return cached
        }
        
        do {
            let remoteLessons = try await remoteDataSource.fetchLessons(for: courseId)
            try? localDataSource.saveLessons(remoteLessons, for: courseId)
            return remoteLessons
        } catch {
            if let cached = try? localDataSource.getCachedLessons(for: courseId), !cached.isEmpty {
                return cached
            }
            throw NetworkError.networkUnavailable
        }
    }
    
    public func toggleLessonCompletion(courseId: Int, lessonId: Int) async throws -> (lessons: [Lesson], newProgress: Int) {
        var lessons = try await getLessons(for: courseId)
        
        guard let index = lessons.firstIndex(where: { $0.id == lessonId }) else {
            throw NetworkError.notFound
        }
        
        lessons[index].isCompleted.toggle()
        
        let newProgress = CourseProgressCalculator.calculateProgress(lessons: lessons)
        
        // Persist updated lessons
        try localDataSource.saveLessons(lessons, for: courseId)
        
        // Update progress in cached course list
        if var cachedCourses = try? localDataSource.getCachedCourses(),
           let courseIndex = cachedCourses.firstIndex(where: { $0.id == courseId }) {
            cachedCourses[courseIndex].progress = newProgress
            try? localDataSource.saveCourses(cachedCourses)
        }
        
        return (lessons, newProgress)
    }
}
