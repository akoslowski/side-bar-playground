import UIKit
import SwiftUI

struct SideBarContentView: View {
    let viewModel: SideBarViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    Button("Dismiss", role: .destructive) {
                        viewModel.actionSubject.send(.dismissTapped)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)

                    Button("Open Green Screen") {
                        viewModel.actionSubject.send(.openGreenSectionTapped)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        // We need to define .stack, otherwise splitview on iPad adds a view on top of the side bar content view
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.actionSubject.send(.viewAppeared)
        }
        .onDisappear {
            viewModel.actionSubject.send(.viewDisappeared)
        }
    }
}
