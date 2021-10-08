//
//  ManageUI.swift
//  Volcanoes
//
//  Created by Даниил Марусенко on 17.08.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit

struct ManageUI {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func manageContainerView(_ containerView: UIView) {
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 3
    }
    
    func manageButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
    }
    
}
