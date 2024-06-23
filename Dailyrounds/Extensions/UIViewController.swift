//
//  UIViewController.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 22/06/24.
//

import UIKit

extension UIViewController {
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Daily rounds", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertLogOut(withMessage message: String , handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Daily rounds", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ (action) in
                handler!(action)
            }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    static let activityIndicator: UIActivityIndicatorView = .init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    static let subView:UIView = .init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    public func startLoading(sender: UIView) {
        
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.clipsToBounds = true
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.color = .darkGray
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.center = UIViewController.subView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        
        DispatchQueue.main.async {
            UIViewController.subView.addSubview(activityIndicator)
        }
        
        DispatchQueue.main.async {
            sender.addSubview(UIViewController.subView)
        }
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        // UIApplication.shared.beginIgnoringInteractionEvents()
    }

    public func stopLoading(sender: UIView) {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            UIViewController.subView.removeFromSuperview()
            sender.isUserInteractionEnabled = true
        }
    }
}
