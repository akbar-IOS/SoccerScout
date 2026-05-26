//
//  RegistrationViewModel.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/23/26.
//

import Foundation
import Observation

@Observable
final class RegistrationViewModel {
    var firstName = ""
    var lastName = ""
    var isRegistered = false

    private var trimmedFirstName: String {
        firstName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedLastName: String {
        lastName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Two-letter initials shown in the preview and later on the home screen.
    var initials: String {
        let firstInitial = trimmedFirstName.first.map(String.init) ?? "?"
        let lastInitial = trimmedLastName.first.map(String.init) ?? "?"
        return (firstInitial + lastInitial).uppercased()
    }

    /// "Akbar A" style preview shown while typing.
    var previewName: String {
        let first = trimmedFirstName.isEmpty ? "__" : trimmedFirstName
        let lastInitial = trimmedLastName.first.map { String($0).uppercased() } ?? "__"
        return "\(first) \(lastInitial)"
    }

    /// The button is enabled only when both names contain real characters.
    var canCreateAccount: Bool {
        !trimmedFirstName.isEmpty && !trimmedLastName.isEmpty
    }

    func createAccount() {
        guard canCreateAccount else { return }
        isRegistered = true
    }
}
