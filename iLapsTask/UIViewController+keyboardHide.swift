//
//  UIViewController+keyboardHide.swift
//  iLapsTask
//
//  Created by keisyrzk on 20.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
