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
            .buttonStyle(SideBarButtonStyle())
        }
        .background(Color(.SideBar.background))
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
