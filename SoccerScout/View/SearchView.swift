//
//  SearchView.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/23/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    let userInitials: String
    let onSelectPlayer: (Player) -> Void

    init(
        userInitials: String = "AK",
        onSelectPlayer: @escaping (Player) -> Void = { _ in }
    ) {
        self.userInitials = userInitials
        self.onSelectPlayer = onSelectPlayer
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ZStack {
                SearchBackground()

                ScrollView {
                    VStack(spacing: 32) {
                        SearchHeader(initials: userInitials)
                        SeasonHeroCard()

                        PlayerSearchBar(
                            searchText: $viewModel.searchText,
                            isLoading: viewModel.isLoading
                        ) {
                            Task { await viewModel.searchPlayers() }
                        }

                        SearchResultsSection(
                            players: viewModel.players,
                            isLoading: viewModel.isLoading,
                            errorMessage: viewModel.errorMessage,
                            hasSearched: viewModel.hasSearched,
                            onSelectPlayer: onSelectPlayer
                        )

                        FavoritesSection()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 34)
                    .padding(.bottom, 90)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

private struct SearchBackground: View {
    var body: some View {
        Color(red: 0.03, green: 0.05, blue: 0.07)
            .ignoresSafeArea()
    }
}

private struct SeasonHeroCard: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.06, green: 0.42, blue: 0.18))

            Image(systemName: "soccerball.inverse")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white.opacity(0.12))
                .frame(width: 150, height: 150)
                .offset(x: 34, y: 32)

            VStack(alignment: .leading, spacing: 18) {
                Text("🌍 SEASON 2025/26")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(2)
                    .foregroundStyle(Color.white.opacity(0.75))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.12))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .clipShape(Capsule())

                VStack(alignment: .leading, spacing: 10) {
                    Text("Discover the world's best talent")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)

                    Text("500,000+ players · Real-time data")
                        .font(.headline)
                        .foregroundStyle(Color.white.opacity(0.72))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(28)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

private struct PlayerSearchBar: View {
    @Binding var searchText: String
    let isLoading: Bool
    let onSearch: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.78))

            TextField(text: $searchText) {
                Text("Search players")
                    .foregroundStyle(Color.white.opacity(0.55))
            }
            .textInputAutocapitalization(.words)
            .submitLabel(.search)
            .foregroundStyle(.white)
            .font(.title3)
            .onSubmit(onSearch)
            .disabled(isLoading)

            Spacer()

            Button(action: onSearch) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0.06, green: 0.68, blue: 0.27))

                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 54, height: 54)
            }
            .disabled(isLoading)
        }
        .padding(.leading, 24)
        .padding(.trailing, 12)
        .padding(.vertical, 14)
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 0.12, green: 0.18, blue: 0.28), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct SearchResultsSection: View {
    let players: [Player]
    let isLoading: Bool
    let errorMessage: String?
    let hasSearched: Bool
    let onSelectPlayer: (Player) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Spacer()

                Text("\(players.count) players")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }

            contentView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if isLoading && players.isEmpty {
            LoadingSearchCard()
        } else if let errorMessage, players.isEmpty {
            SearchMessageCard(
                icon: "exclamationmark.triangle.fill",
                title: "Search unavailable",
                message: errorMessage
            )
        } else if players.isEmpty && hasSearched {
            SearchMessageCard(
                icon: "person.crop.circle.badge.questionmark",
                title: "No players found",
                message: "Try another player name."
            )
        } else if players.isEmpty {
            SearchMessageCard(
                icon: "magnifyingglass",
                title: "You didn't make a search",
                message: "Please first make a search to see players here."
            )
        } else {
            VStack(spacing: 12) {
                if isLoading { LoadingSearchCard() }

                if let errorMessage {
                    SearchMessageCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Search unavailable",
                        message: errorMessage
                    )
                }

                ForEach(players) { player in
                    NavigationLink {
                        PlayerDetailView(player: player)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        PlayerSearchResultRow(player: player)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            onSelectPlayer(player)
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct PlayerSearchResultRow: View {
    let player: Player

    var body: some View {
        HStack(spacing: 14) {
            Text(player.initials)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(Color.green.opacity(0.55))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(player.teamName)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(player.roleTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)

                Text("Score \(player.score)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(red: 0.12, green: 0.18, blue: 0.28), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct LoadingSearchCard: View {
    var body: some View {
        HStack(spacing: 14) {
            ProgressView()
                .tint(.green)

            Text("Searching players...")
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(20)
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct SearchMessageCard: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.green.opacity(0.85))

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.green.opacity(0.18), style: StrokeStyle(lineWidth: 2, dash: [6]))
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct FavoritesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Favorites")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Spacer()

                Text("0 players")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }

            VStack(spacing: 14) {
                Image(systemName: "star.slash.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.green.opacity(0.85))
                    .frame(width: 72, height: 72)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Circle())

                Text("You didn't choose a favorite yet")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Favorite players will appear here after you save them.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .background(Color(red: 0.08, green: 0.11, blue: 0.18))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green.opacity(0.25), style: StrokeStyle(lineWidth: 2, dash: [6]))
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

private struct SearchHeader: View {
    let initials: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.green)

                Image(systemName: "soccerball.inverse")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(12)
            }
            .frame(width: 56, height: 56)
            .shadow(color: .green.opacity(0.25), radius: 12)

            HStack(spacing: 0) {
                Text("Soccer")
                    .foregroundStyle(.white)

                Text("Scout")
                    .foregroundStyle(.green)
            }
            .font(.title)
            .fontWeight(.bold)

            Spacer()

            Text(initials)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 54, height: 54)
                .background(
                    Circle()
                        .fill(Color.blue)
                        .shadow(color: .blue.opacity(0.35), radius: 10)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 3)
                )
        }
    }
}

#Preview {
    SearchView()
}
