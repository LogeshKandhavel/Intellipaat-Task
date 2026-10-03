import Foundation

/// Pure business logic component for calculating course completion progress.
public struct CourseProgressCalculator {
    
    /// Calculates the completion percentage from completed lessons and total lessons.
    ///
    /// - Parameters:
    ///   - completedLessons: Number of completed lessons (>= 0).
    ///   - totalLessons: Total number of lessons in the course (>= 0).
    /// - Returns: Integer percentage between 0 and 100. Returns 0 if totalLessons is 0 to avoid division-by-zero.
    public static func calculateProgress(completedLessons: Int, totalLessons: Int) -> Int {
        guard totalLessons > 0, completedLessons > 0 else {
            return 0
        }
        
        let safeCompleted = min(completedLessons, totalLessons)
        let ratio = Double(safeCompleted) / Double(totalLessons)
        let percentage = Int(round(ratio * 100.0))
        return min(100, max(0, percentage))
    }
    
    /// Calculates completion percentage directly from a list of lessons.
    ///
    /// - Parameter lessons: The array of `Lesson` items.
    /// - Returns: Integer percentage between 0 and 100.
    public static func calculateProgress(lessons: [Lesson]) -> Int {
        let total = lessons.count
        guard total > 0 else { return 0 }
        let completed = lessons.filter { $0.isCompleted }.count
        return calculateProgress(completedLessons: completed, totalLessons: total)
    }
}
