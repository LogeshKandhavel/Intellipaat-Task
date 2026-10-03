import Foundation
import Combine

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    
    @Published public var emailError: String? = nil
    @Published public var passwordError: String? = nil
    @Published public var generalError: String? = nil
    
    @Published public var isLoading: Bool = false
    @Published public var isLoggedIn: Bool = false
    @Published public var currentUser: User? = nil
    
    private let authRepository: AuthRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol = AuthRepository.shared) {
        self.authRepository = authRepository
    }
    
    public func validate() -> Bool {
        emailError = nil
        passwordError = nil
        generalError = nil
        
        var isValid = true
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !isValidEmailFormat(trimmedEmail) {
            emailError = "Enter a valid email"
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        }
        
        return isValid
    }
    
    public func login() async {
        guard !isLoading else { return }
        guard validate() else { return }
        
        isLoading = true
        generalError = nil
        
        do {
            let user = try await authRepository.login(email: email, password: password)
            self.currentUser = user
            self.isLoggedIn = true
            self.isLoading = false
        } catch let error as NetworkError {
            self.generalError = error.errorDescription
            self.isLoading = false
        } catch {
            self.generalError = "Invalid email or password"
            self.isLoading = false
        }
    }
    
    public func fillDemoCredentials() {
        self.email = "test@test.com"
        self.password = "password"
        self.emailError = nil
        self.passwordError = nil
        self.generalError = nil
    }
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
