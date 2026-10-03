import Foundation
import Combine

@MainActor
public final class CourseDetailsViewModel: ObservableObject {
    @Published public var course: Course
    @Published public var lessons: [Lesson] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let courseRepository: CourseRepositoryProtocol
    
    public init(course: Course, courseRepository: CourseRepositoryProtocol = CourseRepository.shared) {
        self.course = course
        self.courseRepository = courseRepository
    }
    
    /// Loads lessons for the course and aligns progress with calculated lesson completion.
    public func loadLessons() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loadedLessons = try await courseRepository.getLessons(for: course.id)
            self.lessons = loadedLessons
            
            // Recalculate progress using pure business logic
            let calculatedProgress = CourseProgressCalculator.calculateProgress(lessons: loadedLessons)
            self.course.progress = calculatedProgress
            self.isLoading = false
        } catch let error as NetworkError {
            self.errorMessage = error.errorDescription
            self.isLoading = false
        } catch {
            self.errorMessage = "Unable to load lessons."
            self.isLoading = false
        }
    }
    
    /// Toggles the completion status of a lesson, recalculates progress, and persists updates.
    public func toggleLesson(_ lesson: Lesson) async {
        // Optimistic UI update for instantaneous responsiveness
        if let index = lessons.firstIndex(where: { $0.id == lesson.id }) {
            lessons[index].isCompleted.toggle()
            let newProgress = CourseProgressCalculator.calculateProgress(lessons: lessons)
            self.course.progress = newProgress
        }
        
        do {
            let (updatedLessons, newProgress) = try await courseRepository.toggleLessonCompletion(
                courseId: course.id,
                lessonId: lesson.id
            )
            self.lessons = updatedLessons
            self.course.progress = newProgress
        } catch {
            // Revert if persistence failed
            await loadLessons()
            self.errorMessage = "Failed to update lesson status."
        }
    }
}
