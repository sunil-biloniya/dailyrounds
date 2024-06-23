//
//  IntroductionVC.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 20/06/24.
//

import UIKit

class IntroductionVC: UIViewController {
    static func storyboardInstance() -> IntroductionVC {
        return IntroductionVC(nibName: String.className(self), bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let vc = LoginSignUpVC.storyboardInstance()
        vc.viewModel.loginType = .login
        self.push(vc)
    }
    @IBAction func didTapSignUp(_ sender: Any) {
        let vc = LoginSignUpVC.storyboardInstance()
        vc.viewModel.loginType = .signup
        self.push(vc)
    }

}
