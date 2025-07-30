import Combine
import OSLog
import SwiftUI
import UIKit

@MainActor final class SideBarViewModel {

    enum Action: String {
        case accountTapped
        case favoritesTapped
        case settingsTapped
        case dismissTapped
    }

    let action = PassthroughSubject<Action, Never>()
    var showDestination: ((UIViewController) -> Void)?
    var dismissSideBar: (() -> Void)?

    private var subscriptions = Set<AnyCancellable>()
    private let logger = Logger()

    init() {
        action.sink { [weak self] action in
            guard let self else { return }

            logger.log("\(Self.self):action:\(action.rawValue)")

            switch action {
            case .accountTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Account", image: .accountIcon)
                    )
                )

            case .favoritesTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Favorites", image: .favoritesIcon)
                    )
                )

            case .settingsTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Settings", image: .settingsIcon)
                    )
                )

            case .dismissTapped:
                dismissSideBar?()
            }
        }
        .store(in: &subscriptions)
    }

    deinit {
        logger.log("\(Self.self):\(#function)")
    }
}

// MARK: -

struct DestinationView: View {
    let titleKey: LocalizedStringKey
    let image: ImageResource

    var body: some View {
        ZStack {
            Color(.detailBackground)
            Label(titleKey, image: image)
        }
        .labelStyle(SideBarLabelStyle())
        .ignoresSafeArea()
    }
}
