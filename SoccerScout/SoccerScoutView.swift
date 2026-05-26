//
//  SoccerScoutView.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/23/26.
//

import SwiftUI

struct SoccerScoutView: View {
    let userInitials: String

    @State private var selectedPlayer: Player?

    init(userInitials: String = "AK") {
        self.userInitials = userInitials
    }

    var body: some View {
        TabView {
            SearchView(userInitials: userInitials) { player in
                selectedPlayer = player
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            PlayerDetailView(player: selectedPlayer)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Detail")
                }
        }
        .tint(.green)
    }
}

#Preview {
    SoccerScoutView()
}
