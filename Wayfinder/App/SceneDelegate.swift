import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let rootNavigationController: UINavigationController = .init(navigationBarClass: nil, toolbarClass: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        rootNavigationController.viewControllers = [StartViewController()]
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}
