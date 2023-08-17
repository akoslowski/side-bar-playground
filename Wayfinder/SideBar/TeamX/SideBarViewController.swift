import UIKit
import SwiftUI
import OSLog

private let logger = Logger(subsystem: #file, category: "SideBarViewController")

class SideBarViewController: UIHostingController<SideBarContentView> {

    let viewModel = SideBarViewModel()

    init() {
        super.init(rootView: SideBarContentView(viewModel: viewModel))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.pushViewController = { [weak self] viewController in
            guard let self else { return }

            if let presentingNavigationController = presentingViewController as? UINavigationController {
                presentingNavigationController.pushViewController(viewController, animated: false)
            } else {
                presentingViewController?.present(viewController, animated: false)
            }
        }

        viewModel.dismissViewController = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(#function)
    }
}
