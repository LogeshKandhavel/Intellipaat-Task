import SwiftUI

public struct CourseCardView: View {
    public let course: Course
    public var onContinue: () -> Void
    
    public init(course: Course, onContinue: @escaping () -> Void = {}) {
        self.course = course
        self.onContinue = onContinue
    }
    
    // Category pill helpers based on course title
    private var categoryInfo: (name: String, icon: String, color: Color) {
        if course.title.localizedCaseInsensitiveContains("Python") {
            return ("Programming", "curlybraces", Color(red: 0.18, green: 0.55, blue: 0.95))
        } else if course.title.localizedCaseInsensitiveContains("AI") {
            return ("AI & ML", "sparkles", Color(red: 0.60, green: 0.25, blue: 0.95))
        } else if course.title.localizedCaseInsensitiveContains("Full Stack") || course.title.localizedCaseInsensitiveContains("Web") {
            return ("Web Dev", "desktopcomputer", Color(red: 0.05, green: 0.70, blue: 0.70))
        } else {
            return ("Tech Course", "book.closed.fill", AppTheme.primaryColor)
        }
    }
    
    // Instructor initials for avatar
    private var instructorInitials: String {
        let components = course.instructor.components(separatedBy: " ")
        if components.count >= 2, let first = components.first?.first, let second = components.last?.first {
            return "\(first)\(second)"
        }
        return String(course.instructor.prefix(2)).uppercased()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header: Category Pill & Status Badge
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: categoryInfo.icon)
                        .font(.system(size: 11, weight: .bold))
                    Text(categoryInfo.name)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(categoryInfo.color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(categoryInfo.color.opacity(0.12))
                .clipShape(Capsule())
                
                Spacer()
                
                if course.progress == 100 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                        Text("Completed")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(AppTheme.successColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(AppTheme.successColor.opacity(0.12))
                    .clipShape(Capsule())
                } else if course.progress > 0 {
                    Text("\(course.progress)% Done")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.primaryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppTheme.primaryColor.opacity(0.10))
                        .clipShape(Capsule())
                }
            }
            
            // Course Title
            Text(course.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Instructor Info
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [categoryInfo.color.opacity(0.8), categoryInfo.color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    
                    Text(instructorInitials)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Instructor")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(course.instructor)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                }
            }
            
            // Progress Bar Section
            VStack(alignment: .leading, spacing: 6) {
                ProgressBarView(progress: course.progress, height: 7, showPercentageLabel: false)
            }
            .padding(.top, 2)
            
            // Divider line
            Divider()
                .opacity(0.6)
            
            // Footer: Lessons count & Modern Continue Button
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    Text("\(course.lessons) Lessons")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onContinue) {
                    HStack(spacing: 5) {
                        Text(course.progress == 100 ? "Review" : (course.progress > 0 ? "Continue" : "Start"))
                            .font(.system(size: 13, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        course.progress == 100
                        ? AppTheme.successGradient
                        : AppTheme.primaryGradient
                    )
                    .clipShape(Capsule())
                    .contentShape(Capsule())
                    .shadow(
                        color: (course.progress == 100 ? AppTheme.successColor : AppTheme.primaryColor).opacity(0.25),
                        radius: 5,
                        x: 0,
                        y: 3
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(18)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

