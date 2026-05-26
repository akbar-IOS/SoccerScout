//
//  PlayerDetailView.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/23/26.
//

import SwiftUI

struct PlayerDetailView: View {
    @State private var viewModel: PlayerDetailViewModel

    init(player: Player? = nil) {
        _viewModel = State(initialValue: PlayerDetailViewModel(player: player))
    }

    var body: some View {
        ZStack {
            PlayerDetailBackground()

            ScrollView {
                VStack(spacing: 28) {
                    PlayerDetailHeader()

                    if let player = viewModel.player {
                        PlayerAPIDetailsCard(player: player, rows: viewModel.infoRows)
                    } else {
                        EmptyPlayerDetailCard()
                    }

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
            .scrollIndicators(.hidden)
        }
    }
}

private struct PlayerDetailBackground: View {
    var body: some View {
        Color(red: 0.03, green: 0.05, blue: 0.07)
            .ignoresSafeArea()
    }
}

private struct PlayerDetailHeader: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            HStack(spacing: 14) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white.opacity(0.65))
                }

                Text("Player Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            Spacer()

            Image(systemName: "star.fill")
                .font(.system(size: 34))
                .foregroundStyle(.yellow)
                .shadow(color: .yellow.opacity(0.4), radius: 8)
        }
    }
}

private struct EmptyPlayerDetailCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 46, weight: .semibold))
                .foregroundStyle(.green)

            Text("You didn't make a search")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Please first make a search and choose a player to see player info here.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 42)
        .padding(.horizontal, 24)
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.green.opacity(0.25), style: StrokeStyle(lineWidth: 2, dash: [6]))
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

private struct PlayerAPIDetailsCard: View {
    let player: Player
    let rows: [PlayerAPIInfoRow]

    var body: some View {
        VStack(spacing: 0) {
            PlayerAPIHeroSection(player: player)
            PlayerScoreSection(score: player.score)
            PlayerAPIInfoSection(rows: rows)
        }
        .background(Color(red: 0.08, green: 0.11, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(red: 0.13, green: 0.20, blue: 0.30), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

private struct PlayerAPIHeroSection: View {
    let player: Player

    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.42, blue: 0.18),
                    Color(red: 0.07, green: 0.68, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "soccerball.inverse")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white.opacity(0.14))
                .frame(width: 130, height: 130)
                .offset(x: 22, y: 10)

            HStack(spacing: 24) {
                Text(player.initials)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 112, height: 112)
                    .background(Color.white.opacity(0.22))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.55), lineWidth: 5)
                    )

                VStack(alignment: .leading, spacing: 10) {
                    Text(player.name)
                        .font(.system(size: 31, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)

                    Text(player.teamName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white.opacity(0.75))

                    Text("\(player.roleTitle) · ID \(player.id)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.black.opacity(0.28))
                        .clipShape(Capsule())
                }

                Spacer(minLength: 0)
            }
            .padding(28)
        }
        .frame(height: 220)
    }
}

private struct PlayerScoreSection: View {
    let score: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.green)

            Text("API SCORE")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(2)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 0.13, green: 0.20, blue: 0.30))
                .frame(height: 1)
        }
    }
}

private struct PlayerAPIInfoSection: View {
    let rows: [PlayerAPIInfoRow]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(rows) { row in
                PlayerAPIInfoRowView(row: row)

                if row.id != rows.last?.id {
                    Rectangle()
                        .fill(Color.white.opacity(0.04))
                        .frame(height: 1)
                        .padding(.leading, 46)
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 18)
    }
}

private struct PlayerAPIInfoRowView: View {
    let row: PlayerAPIInfoRow

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: row.icon)
                .font(.headline)
                .foregroundStyle(Color.white.opacity(0.55))
                .frame(width: 28)

            Text(row.title)
                .font(.headline)
                .foregroundStyle(.gray)

            Spacer()

            Text(row.value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(row.isHighlighted ? .green : .white)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 17)
    }
}

#Preview {
    PlayerDetailView()
}
