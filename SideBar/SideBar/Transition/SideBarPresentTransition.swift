import UIKit

final class SideBarPresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

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
        guard let toView = context.view(forKey: .to) else {
            return UIViewPropertyAnimator()
        }

        let duration = transitionDuration(using: context)
        let containerView = context.containerView

        containerView.addSubview(toView)

        toView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            toView.topAnchor.constraint(equalTo: containerView.topAnchor),
            toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            toView.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor)
        ])

        toView.transform = CGAffineTransform(translationX: -toView.intrinsicContentSize.width, y: 0.0)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        self.animator = animator

        animator.addAnimations {
            toView.transform = .identity
        }

        animator.addCompletion { position in
            Task { @MainActor in
                switch position {
                case .end where context.transitionWasCancelled:
                    context.completeTransition(false)
                case .end:
                    context.completeTransition(true)
                default:
                    context.completeTransition(false)
                }
            }
        }

        animator.addCompletion { [unowned self] _ in
            Task { @MainActor in
                self.animator = nil
            }
        }

        return animator
    }

    func interruptibleAnimator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator ?? transitionAnimator(using: context)
    }
}
