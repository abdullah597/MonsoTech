//
//  UIColor+Extensions.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 23/06/2024.
//

import UIKit

extension UIColor{
    
    static var appColor: UIColor?{
        return hexStringToUIColor(hex: "015AA5")
    }
    static var textGreyColor: UIColor? {
        return hexStringToUIColor(hex: "9CA3AF")
    }
    
    static var greenColor: UIColor? {
        return hexStringToUIColor(hex: "0EAD69")
    }
    
    static var redColor: UIColor? {
        return hexStringToUIColor(hex: "EB5757")
    }
    static var greenLightColor: UIColor? {
        return hexStringToUIColor(hex: "D9F2D9")
    }
    
    static var redLightColor: UIColor? {
        return hexStringToUIColor(hex: "F2D9D9")
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UIImage {
    static var clockgreen: UIImage? {
        return UIImage(named: "clockgreen")
    }
    static var calendargreen: UIImage? {
        return UIImage(named: "calendargreen")
    }
    static var clockred: UIImage? {
        return UIImage(named: "clock")
    }
    static var calendarred: UIImage? {
        return UIImage(named: "calendar")
    }
}
