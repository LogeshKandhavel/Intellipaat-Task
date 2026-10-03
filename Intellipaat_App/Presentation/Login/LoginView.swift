import SwiftUI

public struct LoginView: View {
    @ObservedObject public var viewModel: LoginViewModel
    public var onLoginSuccess: () -> Void
    
    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case email
        case password
    }
    
    public init(viewModel: LoginViewModel, onLoginSuccess: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.onLoginSuccess = onLoginSuccess
    }
    
    public var body: some View {
        ZStack {
            // Ambient background lighting
            AppTheme.pageBackground
                .ignoresSafeArea()
            
            // Soft ambient gradient glows in background
            GeometryReader { proxy in
                Circle()
                    .fill(AppTheme.primaryColor.opacity(0.08))
                    .frame(width: 320, height: 320)
                    .blur(radius: 60)
                    .offset(x: proxy.size.width * 0.5, y: -60)
                
                Circle()
                    .fill(AppTheme.accentColor.opacity(0.06))
                    .frame(width: 280, height: 280)
                    .blur(radius: 50)
                    .offset(x: -80, y: proxy.size.height * 0.45)
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer(minLength: 24)
                    
                    // App Branding Hero Header
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.primaryColor.opacity(0.2),
                                            AppTheme.accentColor.opacity(0.12)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 88, height: 88)
                                .shadow(color: AppTheme.primaryColor.opacity(0.2), radius: 16, x: 0, y: 8)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(AppTheme.primaryGradient)
                        }
                        
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text("INTELLIPAAT")
                                    .font(.system(size: 11, weight: .black))
                                    .tracking(2.5)
                                    .foregroundColor(AppTheme.primaryColor)
                            }
                            
                            Text("Welcome Back")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Empower your career with top tech skills")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 12)
                    
                    // Form Card Container
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 15))
                                    .foregroundColor(focusedField == .email ? AppTheme.primaryColor : Color(UIColor.systemGray2))
                                    .frame(width: 20)
                                
                                TextField("Enter your email", text: $viewModel.email)
                                    .focused($focusedField, equals: .email)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                                    .keyboardType(.emailAddress)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(UIColor.tertiarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        viewModel.emailError != nil
                                        ? AppTheme.errorColor
                                        : (focusedField == .email ? AppTheme.primaryColor : Color(UIColor.separator).opacity(0.4)),
                                        lineWidth: focusedField == .email || viewModel.emailError != nil ? 1.5 : 1
                                    )
                            )
                            
                            if let emailError = viewModel.emailError {
                                HStack(spacing: 5) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                    Text(emailError)
                                        .font(.caption.weight(.medium))
                                }
                                .foregroundColor(AppTheme.errorColor)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 15))
                                    .foregroundColor(focusedField == .password ? AppTheme.primaryColor : Color(UIColor.systemGray2))
                                    .frame(width: 20)
                                
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $viewModel.password)
                                        .focused($focusedField, equals: .password)
                                        .font(.system(size: 15))
                                } else {
                                    SecureField("Enter your password", text: $viewModel.password)
                                        .focused($focusedField, equals: .password)
                                        .font(.system(size: 15))
                                }
                                
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(UIColor.systemGray2))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(UIColor.tertiarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        viewModel.passwordError != nil
                                        ? AppTheme.errorColor
                                        : (focusedField == .password ? AppTheme.primaryColor : Color(UIColor.separator).opacity(0.4)),
                                        lineWidth: focusedField == .password || viewModel.passwordError != nil ? 1.5 : 1
                                    )
                            )
                            
                            if let passwordError = viewModel.passwordError {
                                HStack(spacing: 5) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                    Text(passwordError)
                                        .font(.caption.weight(.medium))
                                }
                                .foregroundColor(AppTheme.errorColor)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // General Login Error Area
                        if let generalError = viewModel.generalError {
                            HStack(spacing: 10) {
                                Image(systemName: "xmark.octagon.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.errorColor)
                                Text(generalError)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(AppTheme.errorColor)
                                Spacer()
                            }
                            .padding(14)
                            .background(AppTheme.errorColor.opacity(0.12))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppTheme.errorColor.opacity(0.25), lineWidth: 1)
                            )
                            .transition(.opacity)
                        }
                        
                        // Login CTA Button
                        Button {
                            focusedField = nil
                            Task {
                                await viewModel.login()
                                if viewModel.isLoggedIn {
                                    onLoginSuccess()
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                    Text("Signing in...")
                                        .font(.system(size: 16, weight: .bold))
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 16, weight: .bold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                viewModel.isLoading
                                ? LinearGradient(colors: [AppTheme.primaryColor.opacity(0.6), AppTheme.primaryColor.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
                                : AppTheme.primaryGradient
                            )
                            .foregroundColor(.white)
                            .cornerRadius(AppTheme.buttonCornerRadius)
                            .shadow(color: AppTheme.primaryColor.opacity(viewModel.isLoading ? 0.0 : 0.35), radius: 10, x: 0, y: 5)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 4)
                    }
                    .padding(22)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
                    
                    // Feature Badges Footer
                    HStack(spacing: 16) {
                        featurePill(icon: "checkmark.shield.fill", text: "Secure")
                        featurePill(icon: "wifi.slash", text: "Offline Ready")
                        featurePill(icon: "checkmark.seal.fill", text: "Certified")
                    }
                    .padding(.top, 4)
                    
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func featurePill(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AppTheme.primaryColor)
            Text(text)
                .font(.caption2.weight(.medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.8))
        .clipShape(Capsule())
    }
}

