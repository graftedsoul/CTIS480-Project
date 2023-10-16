//
//  RadiıoButton.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 14.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/29117759/how-to-create-radio-buttons-and-checkbox-in-swift-ios

class RadioButton: UIButton {
    var alternateButtons:Array<RadioButton>?
    
    func unselectAlternateButtons() {
        if alternateButtons != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButtons! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 0)
            }
        }
    }
}
