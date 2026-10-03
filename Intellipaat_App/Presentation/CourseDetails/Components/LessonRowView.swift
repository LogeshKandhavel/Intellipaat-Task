import SwiftUI

public struct LessonRowView: View {
    public let lesson: Lesson
    public var onToggle: () -> Void
    
    public init(lesson: Lesson, onToggle: @escaping () -> Void) {
        self.lesson = lesson
        self.onToggle = onToggle
    }
    
    public var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                // Status icon
                Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(lesson.isCompleted ? AppTheme.successColor : Color(UIColor.systemGray3))
                    .frame(width: 28, height: 28)
                
                // Lesson Title and Status
                VStack(alignment: .leading, spacing: 3) {
                    Text(lesson.title)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .strikethrough(lesson.isCompleted, color: .secondary.opacity(0.6))
                    
                    Text(lesson.isCompleted ? "Completed" : "Pending")
                        .font(.caption)
                        .foregroundColor(lesson.isCompleted ? AppTheme.successColor : .secondary)
                }
                
                Spacer()
                
                // Tap hint
                Text(lesson.isCompleted ? "Completed" : "Tap to complete")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(6)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(AppTheme.cardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lesson.isCompleted ? AppTheme.successColor.opacity(0.3) : Color(UIColor.separator).opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(lesson.title), \(lesson.isCompleted ? "Completed" : "Pending")")
        .accessibilityHint("Double tap to toggle completion status")
    }
}
