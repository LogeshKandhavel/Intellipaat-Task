import SwiftUI

@main
struct Intellipaat_AppApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    CourseDashboardView(onLogout: {
                        withAnimation {
                            isAuthenticated = false
                            loginViewModel.isLoggedIn = false
                            loginViewModel.password = ""
                        }
                    })
                    .transition(.opacity)
                } else {
                    LoginView(viewModel: loginViewModel, onLoginSuccess: {
                        withAnimation {
                            isAuthenticated = true
                        }
                    })
                    .transition(.opacity)
                }
            }
        }
    }
}
