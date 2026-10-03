import Foundation

public protocol CourseRemoteDataSourceProtocol: AnyObject, Sendable {
    func fetchCourses() async throws -> [Course]
    func fetchLessons(for courseId: Int) async throws -> [Lesson]
    
    var isSimulatingOffline: Bool { get set }
    var isSimulatingEmpty: Bool { get set }
    var isSimulatingError: Bool { get set }
}
