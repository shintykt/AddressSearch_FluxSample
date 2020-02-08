//
//  UIViewExtension.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import UIKit

extension UIView {
    func createBorder() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func createShadow() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}
