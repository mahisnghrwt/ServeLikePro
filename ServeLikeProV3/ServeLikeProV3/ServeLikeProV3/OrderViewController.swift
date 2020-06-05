//
//  OrderViewController.swift
//  ServeLikeProV3
//
//  Created by mahi on 18/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{

    var selectedStaffIndex_: Int?
    var orderList_ = [OrderObject]()
    var selectedCellIndex_: IndexPath = IndexPath(row: -1, section: -1)
    var lastSelectedCellIndex_: IndexPath = IndexPath(row: -1, section: -1)
    
    @IBOutlet weak var orderTableView_: UITableView!
    @IBOutlet weak var staffPickerView_: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        orderTableView_.dataSource = self
        orderTableView_.delegate = self
        orderTableView_.estimatedRowHeight = 60
        orderTableView_.rowHeight = UITableView.automaticDimension
        
        staffPickerView_.delegate = self
        staffPickerView_.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView_.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath as IndexPath)
        var orderInfo: String = utilityClass.staffTable[0][orderList_[indexPath.row].staffID_] + "\t"
        orderInfo += String(orderList_[indexPath.row].tableNumber_) + "\t"
        orderInfo += String(orderList_[indexPath.row].totalCost_) + "\n"
        for dish in orderList_[indexPath.row].selectedDishes_ {
            orderInfo += dish.dishName_ + "\n"
            print(dish.dishName_)
            print(orderInfo)
        }
        
//        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = orderInfo
        
        
//        cell.textLabel.layer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex_ = indexPath
        orderTableView_.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        if (lastSelectedCellIndex_.row != -1) {
            orderTableView_.reloadRows(at: [selectedCellIndex_], with: UITableView.RowAnimation.automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == selectedCellIndex_.row) {
            return CGFloat(orderList_[selectedCellIndex_.row].selectedDishes_.count * 40)
        }
        else {
            return 40
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return utilityClass.staffTable[0].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return utilityClass.staffTable[0][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStaffIndex_ = row
        getData()
        orderTableView_.reloadData()
        print(utilityClass.staffTable[0][row])
    }
    
    func getData() {
        orderList_.removeAll()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Orders")
        request.returnsObjectsAsFaults = false
        if (selectedStaffIndex_ != nil) {
            let predicate = NSPredicate(format: "(staffID == %i)", selectedStaffIndex_!)
            request.predicate = predicate
        }
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                

                let tempOrderObject = OrderObject(staffID: data.value(forKey: "staffID") as! Int, tableNumber: data.value(forKey: "tableNumber") as! Int, orderID: data.value(forKey: "orderID") as! Int, selectedDishes: data.value(forKey: "dish") as! [DishObject])
                
                // Insert the dishes name into the array.
                orderList_.append(tempOrderObject)
                
            }
        } catch {
            print("failed!")
        }
    }
}
