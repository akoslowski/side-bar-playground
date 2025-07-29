import UIKit

class SideBarPresentationController: UIPresentationController {

    private let dismissTransition: SideBarDismissTransition
    private let dismissingPan: (UIPanGestureRecognizer) -> Void
    private lazy var dimmingView = DimmingView()
    private lazy var dismissButton: UIButton = {
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

        containerView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dismissButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismissingPan))
        dismissButton.addGestureRecognizer(panGesture)

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
