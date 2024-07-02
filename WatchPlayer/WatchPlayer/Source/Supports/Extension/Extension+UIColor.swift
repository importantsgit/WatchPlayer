//
//  UIColor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/27/24.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static let primary = UIColor.systemIndigo
    static let primary900 = UIColor(hex: "6D6FC6")
    static let primary600 = UIColor(hex: "8889C5")
    static let primary400 = UIColor(hex: "BABBD8")
    static let primary100 = UIColor(hex: "CACBD9")
    
    static let darkPrimary = UIColor(hex: "2E3088")
    
    static let separator = UIColor(hex: "EEEEEE")
    static let cDarkGray = UIColor(hex: "6C6C6C")
    
    static let title = UIColor(hex: "222222")
    static let subTitle = UIColor(hex: "424242")
    static let subDescription = UIColor(hex: "5D5D5D")
    
    static let disabled = UIColor(hex: "CECECE")
}


