//
//  CheckBox.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 12.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/29117759/how-to-create-radio-buttons-and-checkbox-in-swift-ios

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "tick-inside-circle")! as UIImage
    let uncheckedImage = UIImage(named: "circle")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
