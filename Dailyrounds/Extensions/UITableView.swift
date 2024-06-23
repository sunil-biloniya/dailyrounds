//
//  UITableView.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import Foundation

import UIKit
extension UITableView {
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .medium
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .medium
            }
            activityIndicatorView.color = UIColor.gray
            activityIndicatorView.hidesWhenStopped = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
    
    func addLoadingSection(closure: @escaping (() -> Void)) {
        indicatorView().startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            closure()
        }
    }
    
    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
    
}
extension UITableView {
    func setMessage(message: String?) {
        if message != nil {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .gray
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 14)
            messageLabel.sizeToFit()
            self.backgroundView = messageLabel
        } else {
            self.backgroundView = nil
        }
    }
}
