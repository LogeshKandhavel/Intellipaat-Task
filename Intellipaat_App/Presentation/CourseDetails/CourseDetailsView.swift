import SwiftUI

@MainActor
public struct CourseDetailsView: View {
    @StateObject public var viewModel: CourseDetailsViewModel
    
    public init(course: Course, courseRepository: CourseRepositoryProtocol = CourseRepository.shared) {
        _viewModel = StateObject(wrappedValue: CourseDetailsViewModel(course: course, courseRepository: courseRepository))
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                // Course Header Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.course.title)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Instructor:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.course.instructor)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Progress:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(viewModel.course.progress)%")
                                .font(.headline.bold())
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        
                        ProgressBarView(progress: viewModel.course.progress, height: 9)
                    }
                }
                .padding(18)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .stroke(Color(UIColor.separator).opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                
                // Lessons Section Header
                HStack {
                    Text("Lessons")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    let completedCount = viewModel.lessons.filter { $0.isCompleted }.count
                    Text("\(completedCount) of \(viewModel.lessons.count) Completed")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 4)
                
                // Error message if any
                if let errorMessage = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(AppTheme.errorColor)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(AppTheme.errorColor)
                    }
                    .padding(10)
                    .background(AppTheme.errorColor.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Lessons List
                if viewModel.isLoading && viewModel.lessons.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryColor))
                        Text("Loading lessons...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    LazyVStack(spacing: 12) {
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
        .background(AppTheme.pageBackground.ignoresSafeArea(edges: .bottom))
        .navigationTitle(viewModel.course.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLessons()
        }
    }
}
