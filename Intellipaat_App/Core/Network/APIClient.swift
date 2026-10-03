import Foundation

public protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(url: URL) async throws -> T
}

public final class APIClient: APIClientProtocol {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError("Received invalid status code from server.")
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError
            }
        } catch let netError as NetworkError {
            throw netError
        } catch {
            throw NetworkError.networkUnavailable
        }
    }
}
