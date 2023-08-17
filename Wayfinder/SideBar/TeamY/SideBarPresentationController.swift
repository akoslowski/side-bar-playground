import UIKit

class SideBarPresentationController: UIPresentationController {

    private lazy var dimmingView = DimmingView()
    private let dismissTransition: SideBarDismissTransition
    private let dismissingPan: (UIPanGestureRecognizer) -> Void

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        dimmingView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismissingPan))
        dimmingView.addGestureRecognizer(panGesture)

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
    override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        super.traitCollectionDidChange(previous)
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
