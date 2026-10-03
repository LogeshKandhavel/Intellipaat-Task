import SwiftUI

@MainActor
public struct CourseDashboardView: View {
    @StateObject public var viewModel: CourseDashboardViewModel
    public var onLogout: () -> Void
    
    public init(viewModel: CourseDashboardViewModel? = nil, onLogout: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: viewModel ?? CourseDashboardViewModel())
        self.onLogout = onLogout
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Offline banner indicator if offline simulation is on
                if viewModel.isSimulatingOffline {
                    HStack(spacing: 8) {
                        Image(systemName: "wifi.slash")
                        Text("Simulated Offline Mode Active (Loading Cached Data)")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                }
                
                Group {
                    switch viewModel.state {
                    case .loading:
                        VStack(spacing: 16) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryColor))
                                .scaleEffect(1.3)
                            Text("Loading courses...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .success(let courses):
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(courses) { course in
                                    NavigationLink(value: course) {
                                        CourseCardView(course: course)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                        .refreshable {
                            await viewModel.refresh()
                        }
                        
                    case .empty:
                        VStack(spacing: 16) {
                            Image(systemName: "books.vertical")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            
                            Text("No courses available")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("There are no courses enrolled currently.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                Task { await viewModel.retry() }
                            }) {
                                Text("Retry")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.primaryColor)
                                    .cornerRadius(AppTheme.buttonCornerRadius)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error(let message):
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.errorColor)
                            
                            Text("Unable to load courses.")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                Task { await viewModel.retry() }
                            }) {
                                Text("Retry")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.primaryColor)
                                    .cornerRadius(AppTheme.buttonCornerRadius)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .background(AppTheme.pageBackground.ignoresSafeArea(edges: .bottom))
            .navigationTitle("Courses")
            .navigationDestination(for: Course.self) { course in
                CourseDetailsView(course: course)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section("Demo & Test Controls") {
                            Button(action: {
                                Task { await viewModel.toggleSimulateOffline() }
                            }) {
                                Label(
                                    viewModel.isSimulatingOffline ? "Disable Offline Mode" : "Simulate Offline Mode (Cache Test)",
                                    systemImage: viewModel.isSimulatingOffline ? "wifi" : "wifi.slash"
                                )
                            }
                            
                            Button(action: {
                                Task { await viewModel.toggleSimulateEmpty() }
                            }) {
                                Label(
                                    viewModel.isSimulatingEmpty ? "Show Courses" : "Simulate Empty State",
                                    systemImage: "tray"
                                )
                            }
                            
                            Button(action: {
                                Task { await viewModel.toggleSimulateError() }
                            }) {
                                Label(
                                    viewModel.isSimulatingError ? "Clear Error" : "Simulate API Error",
                                    systemImage: "exclamationmark.octagon"
                                )
                            }
                        }
                        
                        Section {
                            Button(role: .destructive, action: onLogout) {
                                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                    }
                }
            }
            .task {
                await viewModel.loadCourses()
            }
        }
    }
}
