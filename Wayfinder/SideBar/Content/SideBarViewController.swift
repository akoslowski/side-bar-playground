import UIKit
import SwiftUI
import OSLog

final class SideBarViewController: UIHostingController<SideBarContentView> {
    private let logger = Logger(subsystem: URL(filePath: #file).lastPathComponent, category: "SideBarViewController")

    let viewModel = SideBarViewModel()

    init() {
        super.init(rootView: SideBarContentView(viewModel: viewModel))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log("\(Self.self):\(#function)")

        view.backgroundColor = UIColor.clear

        viewModel.showDestination = { [weak self] viewController in
            guard let self else { return }

            if let navigationController = presentingViewController as? UINavigationController {
                // Simulator
                navigationController.pushViewController(viewController, animated: false)
                dismiss(animated: true)
            } else if let presentingViewController {
                // SwiftUI previews
                dismiss(animated: true)
                presentingViewController.present(viewController, animated: true)
            }
        }

        viewModel.dismissSideBar = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log("\(Self.self):\(#function)")
    }
}
