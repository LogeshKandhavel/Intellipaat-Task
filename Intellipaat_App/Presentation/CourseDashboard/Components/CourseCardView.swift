import SwiftUI

public struct CourseCardView: View {
    public let course: Course
    public var onContinue: () -> Void
    
    public init(course: Course, onContinue: @escaping () -> Void = {}) {
        self.course = course
        self.onContinue = onContinue
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Course Title
            Text(course.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            // Instructor
            VStack(alignment: .leading, spacing: 2) {
                Text("Instructor:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(course.instructor)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
            }
            
            // Progress Section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progress:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(course.progress)%")
                        .font(.subheadline.bold())
                        .foregroundColor(AppTheme.primaryColor)
                }
                
                ProgressBarView(progress: course.progress, height: 7)
            }
            
            // Footer: Lessons count and Continue button
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "book.pages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(course.lessons) Lessons")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onContinue) {
                    HStack(spacing: 4) {
                        Text("Continue")
                            .font(.subheadline.weight(.semibold))
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(AppTheme.primaryColor)
                    .cornerRadius(AppTheme.buttonCornerRadius)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(Color(UIColor.separator).opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}
