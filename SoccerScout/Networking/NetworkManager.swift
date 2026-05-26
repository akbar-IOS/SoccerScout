//
//  NetworkManager.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/24/26.
//

import Foundation

// MARK: - Errors

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int, body: String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The request URL could not be created."
        case .invalidResponse:
            "The server returned an invalid response."
        case .badStatusCode(let code, let body):
            "HTTP \(code): \(body)"
        case .decodingFailed(let detail):
            "Decoding failed: \(detail)"
        }
    }
}

// MARK: - Network Manager

final class NetworkManager {
    static let shared = NetworkManager()

    private let apiKey = "4e4f847223mshe36afed308b32a0p1f3d3cjsn95070c10a882"
    private let host = "free-api-live-football-data.p.rapidapi.com"
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    /// Searches players by name through RapidAPI.
    func searchPlayers(search: String) async throws -> [Player] {
        let request = try makeSearchRequest(query: search)

        // Log the outgoing URL so we can see exactly what we're hitting.
        print("➡️ [API] GET", request.url?.absoluteString ?? "nil")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        // Always log the raw body — that's how we know what the server actually sent.
        let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
        print("⬅️ [API] status=\(httpResponse.statusCode)")
        print("⬅️ [API] body=\(bodyString)")

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode, body: bodyString)
        }

        do {
            let decoded = try JSONDecoder().decode(PlayerSearchResponse.self, from: data)
            return decoded.response.suggestions
        } catch {
            print("❌ [API] decoding error:", error)
            throw NetworkError.decodingFailed(String(describing: error))
        }
    }

    // MARK: - Private helpers

    private func makeSearchRequest(query: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/football-players-search"
        components.queryItems = [URLQueryItem(name: "search", value: query)]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(host, forHTTPHeaderField: "x-rapidapi-host")
        return request
    }
}

// MARK: - Response Shape

/// Matches the real API body: `{ "status": ..., "response": { "suggestions": [Player] } }`
private struct PlayerSearchResponse: Decodable {
    let response: SuggestionsContainer

    struct SuggestionsContainer: Decodable {
        let suggestions: [Player]
    }
}
