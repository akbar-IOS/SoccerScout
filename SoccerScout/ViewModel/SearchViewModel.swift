//
//  SearchViewModel.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/24/26.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
    var searchText = ""
    private(set) var players: [Player] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var hasSearched = false

    /// Runs the player search using the trimmed search text.
    func searchPlayers() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            resetResults()
            return
        }

        hasSearched = true
        isLoading = true
        errorMessage = nil

        do {
            let result = try await NetworkManager.shared.searchPlayers(search: query)
            players = result

            if result.isEmpty {
                errorMessage = "No players found for \"\(query)\"."
            }
        } catch {
            players = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func resetResults() {
        hasSearched = false
        players = []
        errorMessage = nil
    }
}
