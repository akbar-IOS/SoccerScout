//
//  Player.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/24/26.
//

import Foundation

struct Player: Identifiable, Decodable, Hashable {
    let id: String
    let type: String
    let score: Int
    let name: String
    let isCoach: Bool
    let teamId: Int
    let teamName: String

    // Explicit CodingKeys keep us safe if the API changes a field name.
    // They also make the JSON mapping easy to read at a glance.
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case score
        case name
        case isCoach
        case teamId
        case teamName
    }

    var initials: String {
        let words = name.split(separator: " ")
        let firstInitial = words.first?.first.map(String.init) ?? "?"
        let secondInitial = words.dropFirst().first?.first.map(String.init) ?? ""
        return (firstInitial + secondInitial).uppercased()
    }

    var roleTitle: String {
        isCoach ? "Coach" : "Player"
    }
}
