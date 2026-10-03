import SwiftUI

@MainActor
public struct CourseDashboardView: View {
    @StateObject public var viewModel: CourseDashboardViewModel
    public var onLogout: () -> Void
    
    @State private var navigationPath: [Course] = []
    
    public init(viewModel: CourseDashboardViewModel? = nil, onLogout: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: viewModel ?? CourseDashboardViewModel())
        self.onLogout = onLogout
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppTheme.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Modern Offline Banner Indicator
                    if viewModel.isSimulatingOffline {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                                .opacity(0.9)
                            
                            Image(systemName: "wifi.slash")
                                .font(.system(size: 13, weight: .bold))
                            
                            Text("Offline Mode • Serving Cached Data")
                                .font(.system(size: 13, weight: .bold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color.orange, Color(red: 0.95, green: 0.45, blue: 0.15)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Main Content States
                    Group {
                        switch viewModel.state {
                        case .loading:
                            loadingStateView
                            
                        case .success(let courses):
                            successStateView(courses: courses)
                            
                        case .empty:
                            emptyStateView
                            
                        case .error(let message):
                            errorStateView(message: message)
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
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
                                    viewModel.isSimulatingOffline ? "Disable Offline Simulation" : "Simulate Offline Mode (Cache Test)",
                                    systemImage: viewModel.isSimulatingOffline ? "wifi" : "wifi.slash"
                                )
                            }
                            
                            Button(action: {
                                Task { await viewModel.toggleSimulateEmpty() }
                            }) {
                                Label(
                                    viewModel.isSimulatingEmpty ? "Show Active Courses" : "Simulate Empty State",
                                    systemImage: "tray"
                                )
                            }
                            
                            Button(action: {
                                Task { await viewModel.toggleSimulateError() }
                            }) {
                                Label(
                                    viewModel.isSimulatingError ? "Clear Error State" : "Simulate API Failure",
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
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryColor.opacity(0.12))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.primaryColor)
                        }
                    }
                }
            }
            .task {
                await viewModel.loadCourses()
            }
        }
    }
    
    // MARK: - Success View with Metrics Header & Cards
    @ViewBuilder
    private func successStateView(courses: [Course]) -> some View {
        let avgProgress = courses.isEmpty ? 0 : Int(round(Double(courses.map(\.progress).reduce(0, +)) / Double(courses.count)))
        let completedCount = courses.filter { $0.progress == 100 }.count
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                
                // Welcome Hero Header Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome Back 👋")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Ready to master new tech skills today?")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.85))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    // 3 Metric Pills
                    HStack(spacing: 10) {
                        metricChip(
                            title: "Enrolled",
                            value: "\(courses.count)",
                            icon: "book.fill"
                        )
                        
                        metricChip(
                            title: "Avg Progress",
                            value: "\(avgProgress)%",
                            icon: "chart.line.uptrend.xyaxis"
                        )
                        
                        metricChip(
                            title: "Completed",
                            value: "\(completedCount)",
                            icon: "checkmark.seal.fill"
                        )
                    }
                }
                .padding(20)
                .background(AppTheme.heroBannerGradient)
                .cornerRadius(22)
                .shadow(color: AppTheme.primaryDark.opacity(0.3), radius: 14, x: 0, y: 7)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Section Title
                HStack {
                    Text("My Courses")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(courses.count) Active")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.primaryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppTheme.primaryColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 18)
                .padding(.top, 4)
                
                // Course List Cards
                LazyVStack(spacing: 16) {
                    ForEach(courses) { course in
                        CourseCardView(course: course, onContinue: {
                            navigationPath.append(course)
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            navigationPath.append(course)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private func metricChip(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
    
    // MARK: - Loading View
    @ViewBuilder
    private var loadingStateView: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryColor.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryColor))
                    .scaleEffect(1.4)
            }
            
            VStack(spacing: 6) {
                Text("Loading Courses")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.primary)
                
                Text("Fetching your latest curriculum and progress...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }
    
    // MARK: - Empty View
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryColor.opacity(0.08))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 42))
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            VStack(spacing: 8) {
                Text("No Courses Available")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("You are not currently enrolled in any courses or the directory is empty.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            Button(action: {
                Task { await viewModel.retry() }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh Catalogue")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppTheme.primaryGradient)
                .clipShape(Capsule())
                .shadow(color: AppTheme.primaryColor.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    @ViewBuilder
    private func errorStateView(message: String) -> some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppTheme.errorColor.opacity(0.12))
                    .frame(width: 88, height: 88)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.errorColor)
            }
            
            VStack(spacing: 8) {
                Text("Unable to Load Courses")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            Button(action: {
                Task { await viewModel.retry() }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppTheme.primaryGradient)
                .clipShape(Capsule())
                .shadow(color: AppTheme.primaryColor.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

