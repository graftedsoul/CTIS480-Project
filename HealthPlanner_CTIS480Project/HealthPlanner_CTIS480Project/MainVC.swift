//
//  MainVC.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 12.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//



/* -------------------------------------------------------- */

/* EZGİ MELİS COŞAR - İPEK GÜNALTAY - CTIS 480 PROJECT */

/* -------------------------------------------------------- */


import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var noUserStack: UIStackView!
    @IBOutlet weak var existingUserStack: UIStackView!
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var getStartedButtonNoUser: UIButton!
    @IBOutlet weak var getStartedButtonExistingUser: UIButton!
    
    @IBOutlet weak var enterNameTextField: UITextField!
    
    @IBOutlet weak var userIcon: UIImageView!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // turn off visibility for all stacks
        noUserStack.isHidden = true
        existingUserStack.isHidden = true
        userIcon.isHidden = true

        // fetch users
        users = DataManager.shared.fetchUsers()
        
        // hide or show stacks based on available users
        if users.count == 0 {
            noUserStack.isHidden = false
            getStartedButtonNoUser.isEnabled = false
        } else {
            existingUserStack.isHidden = false
            
            let u = DataManager.shared.fetchLastUser()
            welcomeLabel.text = "Welcome back, \(u.name!)!"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // turn off visibility for all stacks
        noUserStack.isHidden = true
        existingUserStack.isHidden = true

        // fetch users
        users = DataManager.shared.fetchUsers()
        
        // hide or show stacks based on available users
        if users.count == 0 {
            noUserStack.isHidden = false
            getStartedButtonNoUser.isEnabled = false
        } else {
            existingUserStack.isHidden = false
            
            let u = DataManager.shared.fetchLastUser()
            welcomeLabel.text = "Welcome back, \(u.name!)!"
            //ageLabel.text = "Age: \(u.age)"
            //weightLabel.text = "Weight: \(u.weight) kg"
            //heightLabel.text = "Height: \(u.height) cm"
            print(u.name!)
            userIcon.isHidden = false
            if u.sex{
                userIcon.image = UIImage(named: "male")
            }
            else{
                userIcon.image = UIImage(named: "female")
            }
        }
        
        
        /* self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width/2
        self.userIcon.clipsToBounds = true
        self.userIcon.layer.borderColor = UIColor.white.cgColor
        self.userIcon.layer.borderWidth = 5 */
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // disable the get started button if the user did not enter any names
    @IBAction func nameChanged(_ sender: UITextField) {
        if (sender.text == "") {
            getStartedButtonNoUser.isEnabled = false
        } else {
            getStartedButtonNoUser.isEnabled = true
        }
    }
    
    // perform segue depending on existing users
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // only pass the username if a user is being created
        if users.count == 0 {
            let vc = segue.destination as! SelectVC
            vc.name = enterNameTextField.text!
        }
    }

}
