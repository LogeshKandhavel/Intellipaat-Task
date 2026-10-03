import XCTest
@testable import Intellipaat_App

final class ProgressCalculationTests: XCTestCase {
    
    func testCalculateProgress_twoOfFourCompleted_returnsFiftyPercent() {
        // Arrange
        let totalLessons = 4
        let completedLessons = 2
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(
            completedLessons: completedLessons,
            totalLessons: totalLessons
        )
        
        // Assert
        XCTAssertEqual(progress, 50, "2 out of 4 lessons should result in 50% progress")
    }
    
    func testCalculateProgress_threeOfFourCompleted_returnsSeventyFivePercent() {
        // Arrange
        let totalLessons = 4
        let completedLessons = 3
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(
            completedLessons: completedLessons,
            totalLessons: totalLessons
        )
        
        // Assert
        XCTAssertEqual(progress, 75, "3 out of 4 lessons should result in 75% progress")
    }
    
    func testCalculateProgress_zeroTotalLessons_returnsZeroPercentWithoutCrashing() {
        // Arrange
        let totalLessons = 0
        let completedLessons = 0
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(
            completedLessons: completedLessons,
            totalLessons: totalLessons
        )
        
        // Assert
        XCTAssertEqual(progress, 0, "Zero total lessons must return 0% safely without division by zero crash")
    }
    
    func testCalculateProgress_allLessonsCompleted_returnsOneHundredPercent() {
        // Arrange
        let totalLessons = 10
        let completedLessons = 10
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(
            completedLessons: completedLessons,
            totalLessons: totalLessons
        )
        
        // Assert
        XCTAssertEqual(progress, 100, "All lessons completed must return 100%")
    }
    
    func testCalculateProgress_noLessonsCompleted_returnsZeroPercent() {
        // Arrange
        let totalLessons = 5
        let completedLessons = 0
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(
            completedLessons: completedLessons,
            totalLessons: totalLessons
        )
        
        // Assert
        XCTAssertEqual(progress, 0, "0 completed lessons must return 0%")
    }
    
    func testCalculateProgress_fromLessonModels_calculatesCorrectPercentage() {
        // Arrange
        let lessons = [
            Lesson(id: 1, courseId: 10, title: "Lesson 1", isCompleted: true),
            Lesson(id: 2, courseId: 10, title: "Lesson 2", isCompleted: true),
            Lesson(id: 3, courseId: 10, title: "Lesson 3", isCompleted: false),
            Lesson(id: 4, courseId: 10, title: "Lesson 4", isCompleted: false)
        ]
        
        // Act
        let progress = CourseProgressCalculator.calculateProgress(lessons: lessons)
        
        // Assert
        XCTAssertEqual(progress, 50, "2 of 4 lesson models completed should calculate to 50%")
    }
}
