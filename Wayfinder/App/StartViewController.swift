import UIKit
import SwiftUI
import OSLog

final class StartViewController: UIViewController {
    private let logger = Logger(subsystem: URL(filePath: #file).lastPathComponent, category: "StartViewController")

    // step 1:
    let sideBarTransition = SideBarTransition()

    var customTransitionEnabled: Bool = true

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
        label.text = "Custom transition"
        label.textColor = .darkText

        let toggle = UISwitch()
        toggle.isOn = customTransitionEnabled
        toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)

        let container = UIStackView(arrangedSubviews: [label, toggle])
        container.axis = .horizontal
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 24

        let background = UIView(frame: .zero)
        background.backgroundColor = UIColor(resource: .menuHighlight)
        background.addSubview(container)
        background.layer.cornerRadius = 24
        background.layer.borderWidth = 1
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20),
            container.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
        ])
        return background
    }()

    lazy var randomText: UIView = {
        let label = UILabel(frame: .zero)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
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
            action: #selector(menuButtonTapped)
        )

        view.backgroundColor = .init(resource: .menuBackground)
        title = "Wayfinder"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(randomText)
        view.addSubview(transitionToggle)

        NSLayoutConstraint.activate([
            randomText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            randomText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            randomText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            randomText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            transitionToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transitionToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

        if customTransitionEnabled {
            sideBarViewController.transitioningDelegate = sideBarTransition
            sideBarViewController.modalPresentationStyle = .custom
        }

        present(sideBarViewController, animated: true)
    }

    @objc func toggleDidChange(_ sender: UISwitch) {
        logger.log("Is custom transition enabled? \(sender.isOn, format: .answer)")
        customTransitionEnabled = sender.isOn
    }
    
    @objc func menuButtonTapped(sender: Any?) {
        showSideBar()
    }
}
