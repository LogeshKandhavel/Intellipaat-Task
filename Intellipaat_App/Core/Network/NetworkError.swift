import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidCredentials
    case networkUnavailable
    case serverError(String)
    case decodingError
    case noCachedData
    case notFound
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkUnavailable:
            return "Unable to load courses. Please check your network connection."
        case .serverError(let message):
            return message
        case .decodingError:
            return "Unable to process course data."
        case .noCachedData:
            return "Unable to load courses. No offline data available."
        case .notFound:
            return "Requested item was not found."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}
