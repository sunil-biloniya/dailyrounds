//
//  UITextField.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 22/06/24.
//

import UIKit

extension UITextField {

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func setLeftImage(_ textFieldImg: UIImage) {
        //setting left image
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        let paddingImage = UIImageView()
        paddingImage.tintColor = .black
        paddingImage.image = textFieldImg
        paddingImage.contentMode = .left
        paddingImage.frame = CGRect(x: 0, y: 0, width: 19, height: 40)
        paddingView.addSubview(paddingImage)
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

