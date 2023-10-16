//
//  MainVC.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 13.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView

class HomeVC: UIViewController {
    var currentDate: String?
    
    var audioPlayer: AVAudioPlayer!
    let waterSound = "water"
    let alertSound = "alert"
    
    @IBOutlet weak var waterStack: UIStackView!
    @IBOutlet var waterImageViews: [UIImageView]!
    @IBOutlet weak var waterStepper: UIStepper!
    @IBOutlet weak var waterJsonLabel: UILabel!
    
    @IBOutlet weak var stepsStack: UIStackView!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var stepsJsonLabel: UILabel!
    
    @IBOutlet weak var sleepStack: UIStackView!
    @IBOutlet weak var sleepSlider: UISlider!
    @IBOutlet weak var sleepHoursLAbel: UILabel!
    @IBOutlet weak var sleepJsonLabel: UILabel!
    
    @IBOutlet weak var moodStack: UIStackView!
    @IBOutlet var moodImageViews: [UIButton]!
    @IBOutlet weak var moodJsonLabel: UILabel!
    
    @IBOutlet var doubleTapRecogniser: UITapGestureRecognizer!
    
    @IBOutlet var moodButtons: [RadioButton]!
    
    
    @IBOutlet weak var mottoImage: UIImageView!
    
    @IBOutlet weak var mottoLabel: UILabel!
    let user = DataManager.shared.fetchLastUser()
    let habits = DataManager.shared.fetchUserHabits(user: DataManager.shared.fetchLastUser())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .long
        
        currentDate = format.string(from: Date())
        
        // hide all stacks at first
        waterStack.isHidden = true
        stepsStack.isHidden = true
        sleepStack.isHidden = true
        moodStack.isHidden = true
        mottoImage.isHidden = true
        mottoLabel.isHidden = true
        
        mottoImage.image = UIImage(named: "girlie")

        // if water is tracked
        if habits.trackWater {
            waterStack.isHidden = false
            
            for imageView in waterImageViews {
                imageView.image = UIImage(named: "glass-empty")
            }
            
            let w = DataManager.shared.fetchWaters(user: user, date: currentDate!)
            
            if w != nil {
                waterStepper.value = Double(w?.glasses ?? 0)
            } else {
                waterStepper.value = 0.0
            }
            
            for i in 0...Int(waterStepper.value) {
                if (i - 1 != -1) {
                    waterImageViews[i - 1].image = UIImage(named: "glass-full")
                }
            }
        }
        
        // if mood is tracked
        if habits.trackMood {
            moodStack.isHidden = false
            
            let m = DataManager.shared.fetchMood(user: user, date: currentDate!)
            
            if m == nil {
                // show selected
                for b in moodButtons {
                    b.isSelected = false
                }
            } else {
                // no selected
                moodButtons![Int("\(m!.mood)")!].isSelected = true
            }
        }
        
        // if steps is tracked
        if habits.trackSteps {
            stepsStack.isHidden = false
            
            let s = DataManager.shared.fetchSteps(user: user, date: currentDate!)
            
            if s != nil {
                stepsTextField.text = "\(s?.steps ?? 0)"
            } else {
                stepsTextField.text = "0"
            }
        }
        
        // if sleep is tracked
        if habits.trackSleep {
            sleepStack.isHidden = false
            
            let s = DataManager.shared.fetchSleep(user: user, date: currentDate!)
            
            print(sleepSlider.value)
            print(s?.hours)
            
            if s != nil {
                sleepSlider.value = Float(s!.hours)
            } else {
                sleepSlider.value = 0.0
            }
            
            sleepHoursLAbel.text = String(format: "%.0f", sleepSlider.value)
        }
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            if let jsonToParse = NSData(contentsOfFile: path) {
                
                guard let json = try? JSON(data: jsonToParse as Data) else {
                    print("Error with JSON")
                    return
                }
                
                print(json)
                
                waterJsonLabel.text = json["water"].string!
                stepsJsonLabel.text = json["steps"].string!
                sleepJsonLabel.text = json["sleep"].string!
                moodJsonLabel.text = json["mood"].string!
                mottoLabel.text = json["motto"].string!            }
            else {
                print("NSdata error")
            }
        }
        else {
            print("NSURL error")
        }
    }
    
    func playSound(sound: String) {
        let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
        
        audioPlayer.play()
    }

    
    @IBAction func waterStepperValueChanged(_ sender: UIStepper) {
        playSound(sound: waterSound)
        
        for imageView in waterImageViews {
            imageView.image = UIImage(named: "glass-empty")
        }
        
        for i in 0...Int(sender.value) {
            if (i - 1 != -1) {
                waterImageViews[i - 1].image = UIImage(named: "glass-full")
            }
        }
        
        var w = DataManager.shared.fetchWaters(user: user, date: currentDate!)
        
        if w == nil {
            w = DataManager.shared.createWater(user: user)
            w!.date = currentDate
        }
        
        w?.glasses = Int16(sender.value)
        DataManager.shared.save()
        
        if w?.glasses == 8 {
            let appearance = SCLAlertView.SCLAppearance(
                showCircularIcon: true,
                contentViewColor: UIColor(red: 1, green: 1, blue: 216/255, alpha: 1)
            )
            let alertView = SCLAlertView(appearance: appearance)
            let alertViewIcon = UIImage(named: "water") //Replace the IconImage text with the image name
            alertView.showWarning("Well done!", subTitle: "Drink at least 8 glasses a day to keep your health up", circleIconImage: alertViewIcon)
            
            playSound(sound: "alert")
        }
    }
    
    @IBAction func stepsFieldChanged(_ sender: UITextField) {
        var s = DataManager.shared.fetchSteps(user: user, date: currentDate!)
        
        if s == nil {
            s = DataManager.shared.createSteps(user: user)
            s!.date = currentDate
        }
        
        s?.steps = Int16(sender.text ?? "0") ?? 0
        DataManager.shared.save()
    }
    
    @IBAction func onClickMood(_ sender: UIButton) {
        for b in moodButtons {
            b.isSelected = false
        }
        
        sender.isSelected = true
        
        var m = DataManager.shared.fetchMood(user: user, date: currentDate!)
        
        if m == nil {
            m = DataManager.shared.createMood(user: user)
            m!.date = currentDate
        }
        
        let index: Int = moodButtons.firstIndex(of: sender as! RadioButton)!
        let index16 = Int16(index)
        
        m!.mood = index16
        DataManager.shared.save()
    }
    
    @IBAction func sleepValueChanged(_ sender: UISlider) {
        var s = DataManager.shared.fetchSleep(user: user, date: currentDate!)
        
        if s == nil {
            s = DataManager.shared.createSleep(user: user)
            s!.date = currentDate
        }
        
        let roundedValue = round(sender.value / 1) * 1
        sleepHoursLAbel.text = String(format: "%.0f", roundedValue)
        s?.hours = Int16(roundedValue)
        DataManager.shared.save()
    }
    
    @IBAction func onDoubleTap(_ sender: UITapGestureRecognizer) {
        print("DOUBLE TAP")
        doubleTapRecogniser.isEnabled = false
        mottoLabel.isHidden = false
        mottoImage.isHidden = false
        
        playSound(sound: "yay")
        
        var count = 0
        
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            count += 1
            
            print("poopee")
            
            if count == 5 {
                timer.invalidate()
                self.doubleTapRecogniser.isEnabled = true
                self.mottoLabel.isHidden = true
                self.mottoImage.isHidden = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
