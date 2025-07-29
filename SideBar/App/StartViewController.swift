import OSLog
import SwiftUI
import UIKit

final class StartViewController: UIViewController {
    private let logger = Logger()

    // step 1:
    let sideBarTransition = SideBarTransition()

    var isSideBarTransitionEnabled: Bool = true

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.log("\(Self.self):\(#function)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.log("\(Self.self):\(#function)")
    }

    lazy var transitionToggle: UIView = {
        let label = UILabel(frame: .zero)
        label.text = "SideBar transition"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        let toggle = UISwitch()
        toggle.isOn = isSideBarTransitionEnabled
        toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)

        let container = UIStackView(arrangedSubviews: [label, toggle])
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 24

        let background = UIView(frame: .zero)
        background.backgroundColor = UIColor(resource: .defaultBackground)
        background.addSubview(container)
        background.layer.cornerRadius = 24
        background.layer.borderWidth = 4
        background.layer.borderColor = UIColor(resource: .accent).cgColor
        background.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20),
            container.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
        ])

        return background
    }()

    let words = [
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "sed", "do", "eiusmod", "tempor",
        "incididunt", "ut", "labore", "et", "dolore", "magna", "aliqua", "enim", "ad", "minim", "veniam", "quis", "nostrud",
        "exercitation", "ullamco", "laboris", "nisi", "aliquip", "ex", "ea", "commodo", "consequat",
    ]

    lazy var randomText: UIView = {
        let label = UILabel(frame: .zero)
        label.text = (0...500).map { _ in words.randomElement() ?? "?" }.joined(separator: " ")
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log("\(Self.self):\(#function)")

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(sideBarButtonTapped)
        )

        view.backgroundColor = .init(resource: .defaultBackground)
        title = "Start"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(randomText)
        view.addSubview(transitionToggle)

        NSLayoutConstraint.activate([
            randomText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            randomText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            randomText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            randomText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            transitionToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transitionToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        // step 2:
        sideBarTransition.addPresentingGesture(on: view) { [weak self] in
            self?.showSideBar()
        }
    }

    func showSideBar() {
        logger.log("\(Self.self):\(#function)")

        // step 3:
        let sideBarViewController = SideBarViewController()

        if isSideBarTransitionEnabled {
            sideBarViewController.transitioningDelegate = sideBarTransition
            sideBarViewController.modalPresentationStyle = .custom
        }

        present(sideBarViewController, animated: true)
    }

    @objc func toggleDidChange(_ sender: UISwitch) {
        isSideBarTransitionEnabled = sender.isOn
    }

    @objc func sideBarButtonTapped(sender: Any?) {
        showSideBar()
    }
}

// MARK: -

#Preview {
    UINavigationController(rootViewController: StartViewController())
}

#Preview(traits: .landscapeLeft) {
    UINavigationController(rootViewController: StartViewController())
}
