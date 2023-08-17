import UIKit

class SideBarDismissTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    private var animator: UIViewPropertyAnimator?

    override init() {
        super.init()
        wantsInteractiveStart = false
    }

    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }

    func animateTransition(using context: UIViewControllerContextTransitioning) {
        transitionAnimator(using: context).startAnimation()
    }

    func transitionAnimator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {

        guard let fromView = context.view(forKey: .from) else {
            return UIViewPropertyAnimator()
        }

        let duration = transitionDuration(using: context)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        self.animator = animator

        animator.addAnimations {
            fromView.transform = .init(translationX: -1 * fromView.bounds.width, y: 0)
        }

        animator.addCompletion { position in
            switch position {
            case .end where context.transitionWasCancelled:
                context.completeTransition(false)
            case .end:
                context.completeTransition(true)
            default:
                context.completeTransition(false)
            }
        }

        animator.addCompletion { [unowned self] _ in
            self.animator = nil
        }

        return animator
    }

    func interruptibleAnimator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator ?? transitionAnimator(using: context)
    }
}
