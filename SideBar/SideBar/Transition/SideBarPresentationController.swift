import UIKit

class SideBarPresentationController: UIPresentationController {

    private lazy var dimmingView = DimmingView()
    private let dismissTransition: SideBarDismissTransition
    private let dismissingPan: (UIPanGestureRecognizer) -> Void
    private lazy var a11yDismissButton: UIButton = { 
        let button = UIButton(
            primaryAction: UIAction(handler: { [weak self] action in
                self?.handleTap()
            })
        )
        button.accessibilityLabel = "Dismiss"
        return button
    }()

    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        dismissTransition: SideBarDismissTransition,
        dismissingPan: @escaping (UIPanGestureRecognizer) -> Void
    ) {
        self.dismissTransition = dismissTransition
        self.dismissingPan = dismissingPan
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }

    @objc private func handleDismissingPan(_ gesture: UIPanGestureRecognizer) {
        dismissingPan(gesture)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        presentedView?.layer.masksToBounds = true
        presentedView?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        presentedView?.layer.cornerRadius = 20

        guard let containerView else { return }

        containerView.addSubview(dimmingView)

        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        containerView.addSubview(a11yDismissButton)
        a11yDismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            a11yDismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            a11yDismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            a11yDismissButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            a11yDismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismissingPan))
        a11yDismissButton.addGestureRecognizer(panGesture)

        dimmingView.alpha = 0.0
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.dimmingView.alpha = 0.0
        }
    }

    @objc private func handleTap() {
        presentingViewController.dismiss(animated: true)
    }
}

// MARK: - Dimming View

class DimmingView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
