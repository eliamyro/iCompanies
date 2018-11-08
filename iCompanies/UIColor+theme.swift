//
//  UIColor+theme.swift
//  iCompanies
//
//  Created by Elias Myronidis on 07/11/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

extension UIColor {
    static let tealColor = UIColor.rgb(red: 48, green: 164, blue: 182)
    static let darkblue = UIColor.rgb(red: 9, green: 45, blue: 64)
    static let lightRed = UIColor.rgb(red: 247, green: 66, blue: 82)
    static let lightBlue = UIColor.rgb(red: 218, green: 223, blue: 243)
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
