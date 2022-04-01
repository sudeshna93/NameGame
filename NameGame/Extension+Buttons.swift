//
//  Extension+Buttons.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/31/22.
//

import Foundation
import UIKit

class ButtonExtension: UIButton {
    var borderWidth: CGFloat = 3.0
    var bordercolor = UIColor.black.cgColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = bordercolor
        self.layer.borderWidth = borderWidth
    }
}


