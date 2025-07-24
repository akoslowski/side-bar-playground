import Combine
import OSLog
import SwiftUI
import UIKit

@MainActor final class SideBarViewModel {

    enum Action: String {
        case viewAppeared
        case viewDisappeared
        case accountTapped
        case favoritesTapped
        case settingsTapped
        case dismissTapped
    }

    let action = PassthroughSubject<Action, Never>()
    var showDestination: ((UIViewController) -> Void)?
    var dismissSideBar: (() -> Void)?

    private var subscriptions = Set<AnyCancellable>()
    private let logger = Logger(subsystem: URL(filePath: #file).lastPathComponent, category: "SideBarViewModel")

    init() {
        setUpActionHandling()
    }

    func setUpActionHandling() {
        action.sink { [weak self] action in
            guard let self else { return }

            logger.log("\(Self.self):action:\(action.rawValue)")

            switch action {
            case .viewAppeared:
                break

            case .viewDisappeared:
                break

            case .accountTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Account", systemImage: "person.crop.square")
                    )
                )

            case .favoritesTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Favorites", systemImage: "heart")
                    )
                )

            case .settingsTapped:
                showDestination?(
                    UIHostingController(
                        rootView: DestinationView(titleKey: "Settings", systemImage: "gearshape")
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

struct DestinationView: View {
    let titleKey: LocalizedStringKey
    let systemImage: String

    var body: some View {
        ZStack {
            Color(.menuHighlight)
            Label(titleKey, systemImage: systemImage)
        }
        .labelStyle(MenuLabelStyle())
        .ignoresSafeArea()
    }
}
