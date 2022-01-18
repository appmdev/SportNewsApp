//
//  UIColourExtension.swift
//  SportNewsApp
//
//  Created by Mac on 18/01/2022.
//


import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func greenMain() -> UIColor {
        return UIColor.rgb(red: 64, green: 144, blue: 113)
    }
}
