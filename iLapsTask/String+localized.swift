//
//  String+localized.swift
//  iLapsTask
//
//  Created by keisyrzk on 19.09.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation

import Foundation

extension String {
    
    public enum TranslationKey: Int {
        
        case lr_login_title
        case lr_register_title
        
        case l_title
        case r_title
        case l_login_button_title
        case r_register_button_title
        
        case global_email_title
        case global_password_title
        case global_error
        
        case main_ble_title
        
        case alert_retry_button_title
        case alert_ok_button_title
        case alert_email_and_password
        case alert_ble_message
    }
    
    public static func localized(key: TranslationKey, defaultValue: String = "") -> String {
        let localizedString = NSLocalizedString("\(key)", bundle: Bundle.main, value: defaultValue, comment: "\(key)")
        return localizedString
    }
}
