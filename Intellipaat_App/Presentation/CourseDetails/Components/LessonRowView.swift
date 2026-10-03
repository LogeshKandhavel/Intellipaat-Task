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
                // Interactive Status Indicator
                ZStack {
                    if lesson.isCompleted {
                        Circle()
                            .fill(AppTheme.successGradient)
                            .frame(width: 30, height: 30)
                            .shadow(color: AppTheme.successColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .strokeBorder(Color(UIColor.systemGray4), lineWidth: 1.8)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color(UIColor.systemGray6).opacity(0.5)))
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: lesson.isCompleted)
                
                // Lesson Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(lesson.isCompleted ? .secondary : .primary)
                        .strikethrough(lesson.isCompleted, color: .secondary.opacity(0.5))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 6) {
                        Image(systemName: lesson.isCompleted ? "checkmark.circle" : "play.circle")
                            .font(.system(size: 11))
                        Text(lesson.isCompleted ? "Completed" : "Tap to complete")
                            .font(.caption2.weight(.medium))
                    }
                    .foregroundColor(lesson.isCompleted ? AppTheme.successColor : .secondary)
                }
                
                Spacer()
                
                // Status Pill
                if lesson.isCompleted {
                    Text("Done")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(AppTheme.successColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppTheme.successColor.opacity(0.12))
                        .clipShape(Capsule())
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                lesson.isCompleted
                ? AppTheme.cardBackground
                : AppTheme.cardBackground
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        lesson.isCompleted
                        ? AppTheme.successColor.opacity(0.3)
                        : Color(UIColor.separator).opacity(0.2),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(lesson.isCompleted ? 0.02 : 0.03), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(lesson.title), \(lesson.isCompleted ? "Completed" : "Pending")")
        .accessibilityHint("Double tap to toggle completion status")
    }
}

