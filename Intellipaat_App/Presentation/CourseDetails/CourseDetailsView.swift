import SwiftUI

@MainActor
public struct CourseDetailsView: View {
    @StateObject public var viewModel: CourseDetailsViewModel
    
    public init(course: Course, courseRepository: CourseRepositoryProtocol = CourseRepository.shared) {
        _viewModel = StateObject(wrappedValue: CourseDetailsViewModel(course: course, courseRepository: courseRepository))
    }
    
    // Category pill helpers based on course title
    private var categoryInfo: (name: String, icon: String, color: Color) {
        if viewModel.course.title.localizedCaseInsensitiveContains("Python") {
            return ("Programming", "curlybraces", Color(red: 0.18, green: 0.55, blue: 0.95))
        } else if viewModel.course.title.localizedCaseInsensitiveContains("AI") {
            return ("AI & ML", "sparkles", Color(red: 0.60, green: 0.25, blue: 0.95))
        } else if viewModel.course.title.localizedCaseInsensitiveContains("Full Stack") || viewModel.course.title.localizedCaseInsensitiveContains("Web") {
            return ("Web Dev", "desktopcomputer", Color(red: 0.05, green: 0.70, blue: 0.70))
        } else {
            return ("Tech Course", "book.closed.fill", AppTheme.primaryColor)
        }
    }
    
    // Instructor initials
    private var instructorInitials: String {
        let components = viewModel.course.instructor.components(separatedBy: " ")
        if components.count >= 2, let first = components.first?.first, let second = components.last?.first {
            return "\(first)\(second)"
        }
        return String(viewModel.course.instructor.prefix(2)).uppercased()
    }
    
    public var body: some View {
        ZStack {
            AppTheme.pageBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Course Hero Overview Card
                    VStack(alignment: .leading, spacing: 16) {
                        // Category & Status Pills
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
                            
                            if viewModel.course.progress == 100 {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 12))
                                    Text("Completed")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(AppTheme.successColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(AppTheme.successColor.opacity(0.12))
                                .clipShape(Capsule())
                            }
                        }
                        
                        // Title
                        Text(viewModel.course.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        // Instructor Row
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(categoryInfo.color.opacity(0.85))
                                    .frame(width: 32, height: 32)
                                
                                Text(instructorInitials)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Lead Instructor")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text(viewModel.course.instructor)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Divider()
                            .opacity(0.6)
                        
                        // Progress Section with Stats
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Overall Progress")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(viewModel.course.progress)%")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(viewModel.course.progress == 100 ? AppTheme.successColor : AppTheme.primaryColor)
                            }
                            
                            ProgressBarView(progress: viewModel.course.progress, height: 8, showPercentageLabel: false)
                            
                            // Stats Triple Row
                            let completedCount = viewModel.lessons.filter { $0.isCompleted }.count
                            let totalCount = max(viewModel.course.lessons, viewModel.lessons.count)
                            let remainingCount = max(0, totalCount - completedCount)
                            
                            HStack(spacing: 8) {
                                statPill(label: "Total Lessons", value: "\(totalCount)", icon: "books.vertical.fill")
                                statPill(label: "Completed", value: "\(completedCount)", icon: "checkmark.circle.fill")
                                statPill(label: "Remaining", value: "\(remainingCount)", icon: "hourglass")
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(20)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cardCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                            .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                    
                    // Celebration Banner when 100% Completed
                    if viewModel.course.progress == 100 {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.successColor.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(AppTheme.successColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Course Completed! 🎉")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.successColor)
                                Text("You have finished all required lessons.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(14)
                        .background(AppTheme.successColor.opacity(0.08))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppTheme.successColor.opacity(0.25), lineWidth: 1)
                        )
                    }
                    
                    // Error Message Banner if any
                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(AppTheme.errorColor)
                            Text(errorMessage)
                                .font(.caption.weight(.medium))
                                .foregroundColor(AppTheme.errorColor)
                            Spacer()
                        }
                        .padding(12)
                        .background(AppTheme.errorColor.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Lessons Curriculum Section Header
                    HStack {
                        Text("Course Curriculum")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        let completedCount = viewModel.lessons.filter { $0.isCompleted }.count
                        Text("\(completedCount)/\(viewModel.lessons.count) Done")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.primaryColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppTheme.primaryColor.opacity(0.10))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                    
                    // Lessons List
                    if viewModel.isLoading && viewModel.lessons.isEmpty {
                        VStack(spacing: 14) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryColor))
                                .scaleEffect(1.2)
                            Text("Loading lessons...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.lessons) { lesson in
                                LessonRowView(lesson: lesson) {
                                    Task {
                                        await viewModel.toggleLesson(lesson)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(viewModel.course.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLessons()
        }
    }
    
    private func statPill(label: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.primaryColor)
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemGray6).opacity(0.7))
        .cornerRadius(10)
    }
}

