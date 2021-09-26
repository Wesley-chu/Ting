//
//  UIColor+.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation
import UIKit

extension UIColor {
    class var cusLightYellow: UIColor { return #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) }
    class var cusPinkYellow: UIColor { return #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.7960784314, alpha: 1) }
    class var cusDarkGray: UIColor { return #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6980392157, alpha: 1) }
    class var cusLightGray: UIColor { return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1) }
    class var cusIndigo: UIColor { return #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1) }
    
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    
    
}
