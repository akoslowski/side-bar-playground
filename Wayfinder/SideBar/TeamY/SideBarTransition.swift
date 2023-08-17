import UIKit

public class SideBarTransition: NSObject, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {

    private let presentTransition = SideBarPresentTransition()
    private let dismissTransition = SideBarDismissTransition()
    private var showSideBar: (() -> Void)?

    private weak var presentedViewController: UIViewController?

    public func addPresentingGesture(on view: UIView, showSideBar: @escaping () -> Void) {
        self.showSideBar = showSideBar
        self.setUpPresentingPanGesture(on: view)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        presentedViewController = presented
        setUpDismissingPanGesture(on: presented.view)

        return SideBarPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            dismissTransition: dismissTransition,
            dismissingPan: dismissingPan
        )
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        presentTransition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissTransition
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        dismissTransition
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/coordinating_multiple_gesture_recognizers/preferring_one_gesture_over_another
        // 1. gestureRecognizer is always UIScreenEdgePanGestureRecognizer since we only attach the delegate to it.
        // 2. gestureRecognizer should fail before any other gesture recognizer is triggered.
        return true
    }

    // MARK: - Present/Dismiss Gestures

    private func setUpPresentingPanGesture(on view: UIView) {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(presentingPan))
        pan.edges = [.left]
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }

    private func setUpDismissingPanGesture(on view: UIView?) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dismissingPan))
        view?.addGestureRecognizer(pan)
    }

    @objc private func presentingPan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = gesture.view else { return }

        let translation = gesture.translation(in: view)
        let percent = translation.x / view.bounds.size.width
        let velocity = gesture.velocity(in: view).x

        switch gesture.state {
        case .began:
            presentTransition.wantsInteractiveStart = true
            showSideBar?()

        case .changed:
            presentTransition.update(percent)

        case .cancelled:
            presentTransition.cancel()
            presentTransition.wantsInteractiveStart = false

        case .ended where percent > 0.5 || velocity > 0:
            presentTransition.finish()
            presentTransition.wantsInteractiveStart = false

        case .ended:
            presentTransition.cancel()
            presentTransition.wantsInteractiveStart = false

        default:
            break
        }
    }

    @objc private func dismissingPan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }

        let translation = gesture.translation(in: view)
        let percent = translation.x / view.bounds.size.width * -1
        let velocity = gesture.velocity(in: view).x * -1

        switch gesture.state {
        case .began:
            dismissTransition.wantsInteractiveStart = true
            presentedViewController?.dismiss(animated: true, completion: nil)

        case .changed:
            dismissTransition.update(percent)

        case .cancelled:
            dismissTransition.cancel()
            dismissTransition.wantsInteractiveStart = false

        case .ended where percent > 0.5 || velocity > 0:
            dismissTransition.finish()
            dismissTransition.wantsInteractiveStart = false

        case .ended:
            dismissTransition.cancel()
            dismissTransition.wantsInteractiveStart = false

        default:
            break
        }
    }
}
