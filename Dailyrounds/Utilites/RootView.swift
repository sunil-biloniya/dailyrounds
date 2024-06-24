//
//  RootView.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import UIKit
class RootView {
    static let shared = RootView()
    private init() {}
    func setRoot(_ viewController: UIViewController, animated: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        guard let window = windowScene.windows.first else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: animated)

        window.rootViewController = navigationController
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                //self.window!.backgroundColor = UIColor.white
                window.makeKeyAndVisible()
            })
        }
    }
}
