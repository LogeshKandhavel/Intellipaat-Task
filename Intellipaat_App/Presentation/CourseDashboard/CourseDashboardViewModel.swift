import Foundation
import Combine

@MainActor
public final class CourseDashboardViewModel: ObservableObject {
    public enum State: Equatable {
        case loading
        case success([Course])
        case empty
        case error(String)
    }
    
    @Published public var state: State = .loading
    @Published public var isSimulatingOffline: Bool = false
    @Published public var isSimulatingEmpty: Bool = false
    @Published public var isSimulatingError: Bool = false
    @Published public var isOfflineCachedMode: Bool = false
    
    private let courseRepository: CourseRepositoryProtocol
    
    public init(courseRepository: CourseRepositoryProtocol = CourseRepository.shared) {
        self.courseRepository = courseRepository
    }
    
    public func loadCourses() async {
        state = .loading
        
        do {
            let courses = try await courseRepository.getCourses()
            if courses.isEmpty {
                self.state = .empty
            } else {
                self.state = .success(courses)
            }
            self.isOfflineCachedMode = self.isSimulatingOffline || self.isSimulatingError
        } catch let error as NetworkError {
            self.state = .error(error.errorDescription ?? "Unable to load courses.")
        } catch {
            self.state = .error("Unable to load courses.")
        }
    }
    
    public func retry() async {
        await loadCourses()
    }
    
    public func refresh() async {
        await loadCourses()
    }
    
    public func toggleSimulateOffline() async {
        isSimulatingOffline.toggle()
        courseRepository.remoteDataSource.isSimulatingOffline = isSimulatingOffline
        await loadCourses()
    }
    
    public func toggleSimulateEmpty() async {
        isSimulatingEmpty.toggle()
        courseRepository.remoteDataSource.isSimulatingEmpty = isSimulatingEmpty
        await loadCourses()
    }
    
    public func toggleSimulateError() async {
        isSimulatingError.toggle()
        courseRepository.remoteDataSource.isSimulatingError = isSimulatingError
        await loadCourses()
    }
}
