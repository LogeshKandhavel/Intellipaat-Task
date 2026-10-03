import XCTest
@testable import Intellipaat_App

final class CourseRepositoryTests: XCTestCase {
    
    // In-memory mock local data source for isolated testing
    private final class MockLocalDataSource: CourseLocalDataSourceProtocol, @unchecked Sendable {
        var cachedCourses: [Course] = []
        var cachedLessons: [Int: [Lesson]] = [:]
        
        func saveCourses(_ courses: [Course]) throws {
            self.cachedCourses = courses
        }
        
        func getCachedCourses() throws -> [Course] {
            guard !cachedCourses.isEmpty else { throw NetworkError.noCachedData }
            return cachedCourses
        }
        
        func saveLessons(_ lessons: [Lesson], for courseId: Int) throws {
            self.cachedLessons[courseId] = lessons
        }
        
        func getCachedLessons(for courseId: Int) throws -> [Lesson] {
            guard let lessons = cachedLessons[courseId], !lessons.isEmpty else {
                throw NetworkError.noCachedData
            }
            return lessons
        }
        
        func clearCache() throws {
            cachedCourses.removeAll()
            cachedLessons.removeAll()
        }
    }
    
    func testFetchCourses_remoteSuccess_cachesLocally() async throws {
        // Arrange
        let mockRemote = MockRemoteDataSource()
        mockRemote.isSimulatingOffline = false
        let mockLocal = MockLocalDataSource()
        let repository = CourseRepository(remoteDataSource: mockRemote, localDataSource: mockLocal)
        
        // Act
        let courses = try await repository.getCourses()
        
        // Assert
        XCTAssertFalse(courses.isEmpty)
        XCTAssertEqual(mockLocal.cachedCourses.count, courses.count)
        XCTAssertEqual(mockLocal.cachedCourses.first?.title, courses.first?.title)
    }
    
    func testFetchCourses_remoteOffline_fallsBackToCache() async throws {
        // Arrange
        let mockRemote = MockRemoteDataSource()
        let mockLocal = MockLocalDataSource()
        let preloadedCourses = [
            Course(id: 1, title: "Cached Python", instructor: "Instructor A", progress: 50, lessons: 4)
        ]
        try mockLocal.saveCourses(preloadedCourses)
        
        let repository = CourseRepository(remoteDataSource: mockRemote, localDataSource: mockLocal)
        
        // Turn off remote connection
        mockRemote.isSimulatingOffline = true
        
        // Act
        let courses = try await repository.getCourses()
        
        // Assert
        XCTAssertEqual(courses.count, 1)
        XCTAssertEqual(courses.first?.title, "Cached Python")
    }
    
    func testFetchCourses_remoteOfflineWithNoCache_throwsError() async {
        // Arrange
        let mockRemote = MockRemoteDataSource()
        let mockLocal = MockLocalDataSource()
        let repository = CourseRepository(remoteDataSource: mockRemote, localDataSource: mockLocal)
        
        mockRemote.isSimulatingOffline = true
        
        // Act & Assert
        do {
            _ = try await repository.getCourses()
            XCTFail("Should have thrown error when offline with empty cache")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testToggleLessonCompletion_recalculatesProgressAndSaves() async throws {
        // Arrange
        let mockRemote = MockRemoteDataSource()
        let mockLocal = MockLocalDataSource()
        let repository = CourseRepository(remoteDataSource: mockRemote, localDataSource: mockLocal)
        
        let initialLessons = [
            Lesson(id: 101, courseId: 1, title: "Lesson 1", isCompleted: true),
            Lesson(id: 102, courseId: 1, title: "Lesson 2", isCompleted: false),
            Lesson(id: 103, courseId: 1, title: "Lesson 3", isCompleted: false),
            Lesson(id: 104, courseId: 1, title: "Lesson 4", isCompleted: false)
        ]
        try mockLocal.saveLessons(initialLessons, for: 1)
        
        // Act: Mark Lesson 2 as completed (now 2 of 4 completed = 50%)
        let (updatedLessons, newProgress) = try await repository.toggleLessonCompletion(courseId: 1, lessonId: 102)
        
        // Assert
        XCTAssertEqual(newProgress, 50)
        XCTAssertTrue(updatedLessons.first(where: { $0.id == 102 })?.isCompleted == true)
        
        // Act 2: Mark Lesson 3 as completed (now 3 of 4 completed = 75%)
        let (_, secondProgress) = try await repository.toggleLessonCompletion(courseId: 1, lessonId: 103)
        XCTAssertEqual(secondProgress, 75)
    }
}
