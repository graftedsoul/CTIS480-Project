//
//  SelectVC.swift
//  HealthPlanner_CTIS480Project
//
//  Created by CTIS Student on 12.06.2023.
//  Copyright © 2023 CTIS. All rights reserved.
//

import UIKit
import CoreData

class HabitCell: UITableViewCell {
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
}

class SelectVC: UIViewController {
    
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letsGoButton: UIButton!
    
    var name: String?
    
    let habitsAttributes = Array(Habits.entity().attributesByName.keys)
    
    var habitSelected: Bool = false
    var heightEntered: Bool = false
    var weightEntered: Bool = false
    
    var height: Double?
    var weight: Double?
    var age: Int?
    var sex: Bool?
    
    let ages = Array(10...90)
    var tracked: [String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        letsGoButton.isEnabled = false
        
        self.navigationItem.hidesBackButton = true;
        
        print("------------------ User being created: \(name ?? "NO_USER")")
        
        habitSelected = false
        heightEntered = false
        weightEntered = false
    }
    
    @IBAction func heightEdited(_ sender: UITextField) {
        heightEntered = !(heightTextField.text == "")
        checkAllFields()
    }
    
    @IBAction func weightEdited(_ sender: UITextField) {
        weightEntered = !(weightTextField.text == "")
        checkAllFields()
    }
    
    func checkAllFields() {
        letsGoButton.isEnabled = (heightEntered && weightEntered && habitSelected)
    }
    
    @IBAction func onClickLetsGo(_ sender: UIButton) {
        
        // first we create a user with the selected options
        sex = (sexSegment.selectedSegmentIndex == 0)
        age = agePickerView.selectedRow(inComponent: 0) + 10
        height = Double(heightTextField.text!)
        weight = Double(weightTextField.text!)
        
        print("------------------ Adding user: \(name ?? "NO_USER")")
        print("--------------------------- Age: \(age ?? -1)")
        print("--------------------------- Sex: \(sex ?? false)")
        print("--------------------------- Weight: \(weight ?? -1)")
        print("--------------------------- Height: \(height ?? -1)")
        
        let u = DataManager.shared.user(name: name!, sex: sex!, age: age!, weight: weight!, height: height!)
        
        print("------------------ Added user: \(name ?? "NO_USER")")
        print("--------------------------- Number of total users: \(DataManager.shared.fetchUsers().count)")
        
        
        // then the user's trackers are added
        _ = DataManager.shared.habits(trackMood: tracked["trackMood"]!, trackSteps: tracked["trackSteps"]!, trackSleep: tracked["trackSleep"]!, trackWater: tracked["trackWater"]!, user: u)
        
        // save the user
        DataManager.shared.save()
        
        // then we go back to the main page
        self.navigationController?.popToRootViewController(animated: true)
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

// TABLE VIEW RELATED
extension SelectVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // add as many cells as the attributes of habits lol
        return Habits.entity().attributesByName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitCell;
        
        let s = habitsAttributes[indexPath.row]
        
        if let range = s.range(of: "track") {
            cell.nameLabel.text = String(s[range.upperBound...])
            cell.iconImageView.image = UIImage(named: String(s[range.upperBound...]).lowercased())
        }
 
        return cell
    }
    
    // click cell, check a habit :3c
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = tableView.cellForRow(at: indexPath) as! HabitCell
        c.checkBox.isChecked = !c.checkBox.isChecked

        habitSelected = checkAllRows()
        
        checkAllFields()
    }
    
    // checks if at least one habit is selected, if not the user cannot proceed
    func checkAllRows() -> Bool {
        var hmm = [Bool]()
        
        for i in 0..<habitsAttributes.count {
            let indexPath = IndexPath(row: i, section: 0)
            let c = tableView.cellForRow(at: indexPath) as! HabitCell
            
            tracked.updateValue(c.checkBox.isChecked, forKey: "track\(c.nameLabel.text!)")
            
            // print("---------------------- \("track\(c.nameLabel.text!)") : \(tracked["track\(c.nameLabel.text!)"])")
            
            hmm.append(c.checkBox.isChecked)
        }
        
        return hmm.contains(true)
    }
    
    func getIndexPathForSelectedRow() -> IndexPath? {
        var indexPath: IndexPath?
        
        if tableView.indexPathsForSelectedRows!.count > 0 {
            indexPath = tableView.indexPathsForSelectedRows![0] as IndexPath
        }
        
        return indexPath
    }
}

// PICKER VIEW RELATED
extension SelectVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(ages[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age = ages[row + 10]
    }
}
