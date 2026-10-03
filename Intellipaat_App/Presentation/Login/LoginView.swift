import SwiftUI

public struct LoginView: View {
    @ObservedObject public var viewModel: LoginViewModel
    public var onLoginSuccess: () -> Void
    
    public init(viewModel: LoginViewModel, onLoginSuccess: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.onLoginSuccess = onLoginSuccess
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer(minLength: 40)
                
                // App Branding Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.12))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 38))
                            .foregroundColor(AppTheme.primaryColor)
                    }
                    
                    Text("Learning App")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Sign in to access your course dashboard")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 10)
                
                // Form Fields
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        TextField("Enter your email", text: $viewModel.email)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(AppTheme.cornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(viewModel.emailError != nil ? AppTheme.errorColor : Color(UIColor.separator), lineWidth: 1)
                            )
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                        
                        if let emailError = viewModel.emailError {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                Text(emailError)
                                    .font(.caption)
                            }
                            .foregroundColor(AppTheme.errorColor)
                            .transition(.opacity)
                        }
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(AppTheme.cornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                    .stroke(viewModel.passwordError != nil ? AppTheme.errorColor : Color(UIColor.separator), lineWidth: 1)
                            )
                        
                        if let passwordError = viewModel.passwordError {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                Text(passwordError)
                                    .font(.caption)
                            }
                            .foregroundColor(AppTheme.errorColor)
                            .transition(.opacity)
                        }
                    }
                    
                    // General Login Error Area
                    if let generalError = viewModel.generalError {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(AppTheme.errorColor)
                            Text(generalError)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(AppTheme.errorColor)
                            Spacer()
                        }
                        .padding(12)
                        .background(AppTheme.errorColor.opacity(0.1))
                        .cornerRadius(AppTheme.cornerRadius)
                    }
                    
                    // Login Button
                    Button {
                        Task {
                            await viewModel.login()
                            if viewModel.isLoggedIn {
                                onLoginSuccess()
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Logging in...")
                                    .font(.headline)
                            } else {
                                Text("Login")
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(viewModel.isLoading ? AppTheme.primaryColor.opacity(0.7) : AppTheme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(AppTheme.buttonCornerRadius)
                    }
                    .disabled(viewModel.isLoading)
                    
                    // Demo Credentials Helper Button
                    Button {
                        viewModel.fillDemoCredentials()
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Use Demo Credentials (test@test.com / password)")
                                .font(.caption)
                        }
                        .foregroundColor(AppTheme.primaryColor)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadius + 4)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
        .background(AppTheme.pageBackground.ignoresSafeArea())
    }
}
