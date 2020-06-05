//
//  TakeOrderViewController.swift
//  ServeLikeProV3
//
//  Created by mahi on 12/10/19.
//  Copyright © 2019 mad. All rights reserved.
//
import UIKit
import Foundation

class TakeOrderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var staffPickerView_: UIPickerView!
    @IBOutlet weak var dishCategoryTable_: UITableView!
    @IBOutlet weak var selectedDishLabel_: UILabel!
    
    static var selectedStaffIndex_: Int?
    static var selectedTableIndex_: Int?
    let cellIdentifier: String = "DishCategoryCell"
    var selectedDishes_ = [DishObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staffPickerView_.delegate = self
        staffPickerView_.dataSource = self
        
        dishCategoryTable_.delegate = self
        dishCategoryTable_.dataSource = self
        dishCategoryTable_.tableFooterView = UIView()
        
        self.dishCategoryTable_.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        dishCategoryTable_.reloadData()
        
        if (TakeOrderViewController.selectedStaffIndex_ != nil) {
            staffPickerView_.selectRow(TakeOrderViewController.selectedStaffIndex_!, inComponent: 0, animated: true)
        }
        
        if (TakeOrderViewController.selectedTableIndex_ != nil) {
            staffPickerView_.selectRow(TakeOrderViewController.selectedTableIndex_!, inComponent: 1, animated: true)
        }
        
        selectedDishLabel_.text = String(self.selectedDishes_.count) + " dishes selected."
    }
    // *************************** PICKER VIEW FUNCTIONS START ***************************
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        return utilityClass.staffTable[component].count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return utilityClass.staffTable[component][row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            TakeOrderViewController.selectedStaffIndex_ = row
        }
        else if (component == 1) {
            TakeOrderViewController.selectedTableIndex_ = row
        }

        if (TakeOrderViewController.selectedStaffIndex_ != nil) {
            print("selected staff:", utilityClass.staffTable[0][TakeOrderViewController.selectedStaffIndex_!])
        }
        if (TakeOrderViewController.selectedTableIndex_ != nil) {
        print("selected table:", utilityClass.staffTable[1][TakeOrderViewController.selectedTableIndex_!])
            
        }
    }
    
    

// *************************** PICKER VIEW FUNCTIONS END ***************************
    
    func checkFormValidity()->Bool {
        var isValid: Bool = true
        
        if (TakeOrderViewController.selectedStaffIndex_ == nil || TakeOrderViewController.selectedTableIndex_ == nil || selectedDishes_.count <= 0) {
            isValid = false
          
            let alertController = UIAlertController(title: "Error!", message: "Make Sure staff member, table and at least one dish is selected.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        }
        return isValid
    }
    
    // *************************** TABLE VIEW FUNCTIONS STARTS ***************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utilityClass.dishCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.dishCategoryTable_.dequeueReusableCell(withIdentifier: cellIdentifier) as! UITableViewCell
        cell.textLabel?.text = utilityClass.dishCategory[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "dishMenuSegue", sender: self)
    }
    
    @IBAction func reviewOrderAction(_ sender: Any) {
        if (checkFormValidity()) {
            performSegue(withIdentifier: "takeOrderToConfirmSegue", sender: self)
        }
        else {
            print("Order incomplete.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dishMenuSegue") {
            let destinationController = segue.destination as! MenuViewController
            if (selectedDishes_.count > 0) {
                destinationController.selectedDishes_ = self.selectedDishes_
            }
            print("This is executed!")
        }
        else if (segue.identifier == "takeOrderToConfirmSegue") {
            let destinationController = segue.destination as! confirmOrderViewController
            if (selectedDishes_.count > 0) {
                destinationController.selectedDishes_ = self.selectedDishes_
            }
        }
    }
}
