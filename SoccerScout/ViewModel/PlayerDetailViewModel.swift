//
//  PlayerDetailViewModel.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/24/26.
//

import Foundation
import Observation

@Observable
final class PlayerDetailViewModel {
    let player: Player?

    init(player: Player? = nil) {
        self.player = player
    }

    /// Rows shown in the detail card. Building them here keeps the view simple.
    var infoRows: [PlayerAPIInfoRow] {
        guard let player else { return [] }

        return [
            PlayerAPIInfoRow(icon: "number", title: "Player ID", value: player.id),
            PlayerAPIInfoRow(icon: "person.fill", title: "Type", value: player.type.capitalized),
            PlayerAPIInfoRow(icon: "chart.line.uptrend.xyaxis", title: "Score", value: "\(player.score)", isHighlighted: true),
            PlayerAPIInfoRow(icon: "figure.soccer", title: "Role", value: player.roleTitle),
            PlayerAPIInfoRow(icon: "building.2.fill", title: "Team", value: player.teamName),
            PlayerAPIInfoRow(icon: "number.square.fill", title: "Team ID", value: "\(player.teamId)")
        ]
    }
}

struct PlayerAPIInfoRow: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let value: String
    // Used by the view to highlight a row (e.g. the score). Defaults to false.
    var isHighlighted: Bool = false
}
