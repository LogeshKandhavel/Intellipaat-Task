import Foundation

public protocol AuthRepositoryProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
}

public final class AuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    public static let shared = AuthRepository()
    
    public init() {}
    
    public func login(email: String, password: String) async throws -> User {
        // Artificial network delay to simulate real API
        try await Task.sleep(nanoseconds: 700_000_000)
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Mock credentials validation
        if trimmedEmail == "test@test.com" && password == "password" {
            return User(email: trimmedEmail, name: "Student")
        } else {
            throw NetworkError.invalidCredentials
        }
    }
}
