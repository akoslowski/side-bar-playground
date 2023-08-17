import UIKit
import OSLog
import Combine

fileprivate let logger = Logger(subsystem: #file, category: "SideBarViewModel")

class SideBarViewModel {

    enum Action: String {
        case viewAppeared
        case viewDisappeared
        case openGreenSectionTapped
        case dismissTapped
    }

    let actionSubject = PassthroughSubject<Action, Never>()
    var subscriptions = Set<AnyCancellable>()

    var pushViewController: ((UIViewController) -> Void)?
    var dismissViewController: (() -> Void)?

    init() {
        setUpActionHandling()
    }

    func setUpActionHandling() {
        actionSubject.sink { [weak self] action in
            guard let self else { return }

            logger.log("\(action.rawValue)")

            switch action {
            case .viewAppeared:
                break

            case .viewDisappeared:
                break

            case .openGreenSectionTapped:
                let viewController = UIViewController()
                viewController.view.backgroundColor = .systemGreen
                dismissViewController?()
                pushViewController?(viewController)

            case .dismissTapped:
                dismissViewController?()
            }
        }
        .store(in: &subscriptions)
    }

    deinit {
        logger.log("deinit")
    }
}
