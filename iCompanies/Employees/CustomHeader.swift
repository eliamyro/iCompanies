//
//  CustomHeaderView.swift
//  iCompanies
//
//  Created by Elias Myronidis on 06/12/2018.
//  Copyright © 2018 eliamyro. All rights reserved.
//

import UIKit

class CustomHeader: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
