//
//  DoneBar.swift
//  MyTodoApp
//
//  Created by Melanie on 8/23/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func putLayer(textField: UITextField) {
        let border1 = CALayer()
        border1.borderColor = UIColor.white.cgColor
        border1.frame = CGRect(x: 0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: textField.frame.size.height)
        border1.borderWidth = 2.0
        textField.layer.addSublayer(border1)
    }
    
    func customTextField(textField: UITextField, placeholderText: String) {
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor.clear
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    

    
    
}
