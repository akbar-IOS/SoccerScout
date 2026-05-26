//
//  RegistrationView.swift
//  SoccerScout
//
//  Created by Akbar Abdullo on 5/23/26.
//

import SwiftUI

struct RegistrationView: View {
    @State private var viewModel = RegistrationViewModel()
    @FocusState private var focusedField: RegistrationField?

    var body: some View {
        NavigationStack {
            ZStack {
                RegistrationBackground()

                ScrollView {
                    VStack(spacing: 28) {
                        RegistrationHeader()

                        VStack(alignment: .leading, spacing: 18) {
                            Text("Create account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)

                            RegistrationTextField(
                                title: "FIRST NAME",
                                placeholder: "e.g. Akbar",
                                text: $viewModel.firstName,
                                field: .firstName,
                                focusedField: $focusedField,
                                borderColor: .green
                            )

                            RegistrationTextField(
                                title: "LAST NAME",
                                placeholder: "e.g. Smith",
                                text: $viewModel.lastName,
                                field: .lastName,
                                focusedField: $focusedField,
                                borderColor: .green.opacity(0.5)
                            )

                            PreviewDivider()

                            ProfilePreviewCard(
                                initials: viewModel.initials,
                                previewName: viewModel.previewName
                            )

                            RegistrationFooter(
                                canCreateAccount: viewModel.canCreateAccount,
                                onCreateAccount: viewModel.createAccount
                            )
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color.green.opacity(0.25), lineWidth: 4)
                            .shadow(color: .green.opacity(0.25), radius: 18)
                    )
                    .padding(18)
                }
                .scrollIndicators(.hidden)
            }
            .navigationDestination(isPresented: $viewModel.isRegistered) {
                SoccerScoutView(userInitials: viewModel.initials)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

private enum RegistrationField {
    case firstName
    case lastName
}

private struct RegistrationBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.04, blue: 0.08),
                Color(red: 0.01, green: 0.08, blue: 0.04),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct RegistrationHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "soccerball.inverse")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.green)

            Text("Soccer Scout")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
}

private struct RegistrationTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let field: RegistrationField
    let focusedField: FocusState<RegistrationField?>.Binding
    let borderColor: Color

    private var isFocused: Bool {
        focusedField.wrappedValue == field
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(isFocused ? .green : .gray)

            TextField(text: $text) {
                Text(placeholder)
                    .foregroundStyle(Color.white.opacity(0.55))
            }
            .focused(focusedField, equals: field)
            .textFieldStyle(.plain)
            .foregroundStyle(.white)
            .tint(.green)
            .padding()
            .background(isFocused ? Color.green.opacity(0.14) : Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isFocused ? Color.green : borderColor, lineWidth: isFocused ? 3 : 2)
            )
            .shadow(color: isFocused ? .green.opacity(0.55) : .clear, radius: 14)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

private struct PreviewDivider: View {
    var body: some View {
        HStack(spacing: 22) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray.opacity(0.35))

            Text("Preview")
                .font(.headline)
                .foregroundStyle(.gray)

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray.opacity(0.35))
        }
    }
}

private struct ProfilePreviewCard: View {
    let initials: String
    let previewName: String

    var body: some View {
        HStack(spacing: 14) {
            Text(initials)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.green.opacity(0.85))
                .frame(width: 60, height: 60)
                .background(Color(red: 0.04, green: 0.50, blue: 0.20))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(previewName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Your profile will look like this")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer()

            Button("Edit") { }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.green)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color.green.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.45), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(18)
        .background(Color(red: 0.07, green: 0.10, blue: 0.18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.green.opacity(0.35), style: StrokeStyle(lineWidth: 2, dash: [5]))
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct RegistrationFooter: View {
    let canCreateAccount: Bool
    let onCreateAccount: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Button(action: onCreateAccount) {
                Text("Create My Account →")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(red: 0.01, green: 0.12, blue: 0.06))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(buttonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .disabled(!canCreateAccount)
            .opacity(canCreateAccount ? 1 : 0.7)
            .padding(.top, 20)

            VStack(spacing: 4) {
                Text("By continuing you agree to our")
                    .foregroundStyle(.gray)

                HStack(spacing: 4) {
                    Text("Terms of Service")
                        .foregroundStyle(.green)

                    Text("and")
                        .foregroundStyle(.gray)

                    Text("Privacy Policy")
                        .foregroundStyle(.green)
                }
            }
            .font(.caption)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
    }

    private var buttonBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.10, green: 0.68, blue: 0.30),
                Color(red: 0.28, green: 0.86, blue: 0.50)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    RegistrationView()
}
