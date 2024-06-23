//
//  TextFieldView.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import UIKit

class TextFieldView: UIView {
    @IBOutlet weak var text: UITextField!
    @IBOutlet var contentView: UIView!

    
    // Initializers
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    func setUp(title: String, key: UIKeyboardType = .default) {
        text.addDoneButtonOnKeyboard()
        text.placeholder = title
        text.placeHolderColor = .darkGray
        text.keyboardType = key
    }
}
