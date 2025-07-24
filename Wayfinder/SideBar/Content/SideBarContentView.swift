import SwiftUI
import UIKit

struct SideBarContentView: View {
    let viewModel: SideBarViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button {
                    viewModel.action.send(.accountTapped)
                } label: {
                    Label("Account", systemImage: "person.crop.square")
                }
                .padding(.top, 32)

                Button {
                    viewModel.action.send(.favoritesTapped)
                } label: {
                    Label("Favorites", systemImage: "heart")
                }

                Button {
                    viewModel.action.send(.settingsTapped)
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .buttonStyle(MenuButtonStyle())
        }
        .background(Color(.menuBackground))
        .onAppear {
            viewModel.action.send(.viewAppeared)
        }
        .onDisappear {
            viewModel.action.send(.viewDisappeared)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                viewModel.action.send(.dismissTapped)
            } label: {
                Image(systemName: "xmark")
                    .padding(18)
            }
            .accessibilityLabel("Dismiss")
        }
    }
}

// MARK: -

struct MenuLabelStyle: LabelStyle {
    @ScaledMetric var fontSize: CGFloat = 28.0

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration
                .icon

            configuration
                .title
                .padding(.horizontal)
        }
        .foregroundStyle(Color(.menuText))
        .font(.system(size: fontSize, weight: .bold, design: .rounded))
    }
}

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .labelStyle(MenuLabelStyle())
            .padding(12)
            .foregroundStyle(
                configuration.isPressed
                    ? Color(.menuBackground) : Color(.menuText)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(
                        configuration.isPressed
                            ? Color(.menuHighlight) : Color(.menuBackground)
                    )
            }
            .padding(.horizontal)
    }
}

// MARK: -

#Preview {
    NavigationStack {
        SideBarContentView(viewModel: .init())
    }
}

#Preview {
    UINavigationController(rootViewController: StartViewController())
}
