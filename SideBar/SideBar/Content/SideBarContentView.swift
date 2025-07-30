import SwiftUI
import UIKit

struct SideBarContentView: View {
    let viewModel: SideBarViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    viewModel.action.send(.accountTapped)
                } label: {
                    Label("Account", image: .accountIcon)
                }
                Button {
                    viewModel.action.send(.favoritesTapped)
                } label: {
                    Label("Favorites", image: .favoritesIcon)
                }
                Button {
                    viewModel.action.send(.settingsTapped)
                } label: {
                    Label("Settings", image: .settingsIcon)
                }
            }
            .buttonStyle(SideBarButtonStyle())
            .safeAreaInset(edge: .top, alignment: .trailing) {
                Button {
                    viewModel.action.send(.dismissTapped)
                } label: {
                    Image(systemName: "xmark")
                        .padding(18)
                }
                .accessibilityLabel("Dismiss")
            }
        }
        .background(Color(.SideBar.background))
    }
}

// MARK: -

struct SideBarLabelStyle: LabelStyle {
    @ScaledMetric var fontSize: CGFloat = 28.0

    func makeBody(configuration: Configuration) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 0) {
                configuration
                    .icon

                configuration
                    .title
                    .padding(.horizontal)
            }

            configuration
                .title
                .padding(.horizontal)
        }
        .font(.system(size: fontSize, weight: .bold, design: .rounded))
    }
}

struct SideBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .labelStyle(SideBarLabelStyle())
            .padding(12)
            .foregroundStyle(
                configuration.isPressed
                    ? Color(.SideBar.textHighlight) : Color(.SideBar.text)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(
                        configuration.isPressed
                            ? Color(.SideBar.backgroundHighlight) : Color(.SideBar.background)
                    )
            }
            .padding(.horizontal)
    }
}

// MARK: -

#Preview {
    SideBarContentView(viewModel: .init())
}
