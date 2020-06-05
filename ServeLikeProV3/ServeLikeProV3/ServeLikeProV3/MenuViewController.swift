//
//  MenuViewController.swift
//  ServeLikeProV3
//
//  Created by mahi on 11/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Menu table view.
    @IBOutlet weak var menuTableView_: UITableView!

    // To store all the dishes, we fetch from database.
    var dishList_ = [DishObject] ()
    
    // Stores all the selected dishes.
    var selectedDishes_ = [DishObject] ()
    
    let cellReuseIdentifier = "customMenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch the data from database.
        getData()
        
        // We update the quantity of the selected dishes.
        if (selectedDishes_.count > 0) {
            for SELECTEDISH in selectedDishes_ {
                for i in dishList_.indices {
                    if (SELECTEDISH.dishID_ ==  dishList_[i].dishID_) {
                        dishList_[i].dishQnty_ = SELECTEDISH.dishQnty_
                    }
                }
            }
            print("Number of dishes passed:\t", selectedDishes_.count)
        }
        
        print("These dishes are selcted:")
        for dish in dishList_ {
            if (dish.dishQnty_ > 0) {
                print(dish.dishName_, ", ")
            }
        }
        
        // Table view initlialization stuff.
        menuTableView_.delegate = self
        menuTableView_.dataSource = self
        menuTableView_.reloadData()
        
    }
    
    // Number of sections in table view.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishList_.count
    }
    
    // Fill all the cells with data, and return the cells to the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView_.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! MenuCustomCell
        
        cell.delegate = self
        cell.index_ = indexPath.row
        cell.dishImage_.image = UIImage(data:dishList_[indexPath.row].dishImage_,scale:1.0)
        cell.dishName_.text = dishList_[indexPath.row].dishName_
        cell.dishDesc_.text = dishList_[indexPath.row].dishDesc_
        cell.dishQuantity_.text = String(dishList_[indexPath.row].dishQnty_)
        cell.checkQuantity()
       
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // If editing is enabled on table view, then it allows redordering of the dishes.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = dishList_[sourceIndexPath.row]
        dishList_.remove(at: sourceIndexPath.row)
        dishList_.insert(itemToMove, at: destinationIndexPath.row)
    }

    // Toggles the editing property of the table view.
    @IBAction func startEditing(_ sender: Any) {
        self.menuTableView_.isEditing = !self.menuTableView_.isEditing
    }
    
    // Segue function.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Passes the selected dishes array to the 'TakeOrderViewController' when 'done' button is pressed.
        if (segue.identifier == "doneSelectingSegue") {
            checkSelectedDishes()
            let destinationController = segue.destination as! TakeOrderViewController
            destinationController.selectedDishes_ = self.selectedDishes_
        }
    }
    
    // Checks for the selected dishes.
    func checkSelectedDishes() {
        // Make sure to clear the array first.
        selectedDishes_.removeAll()
        
        // If the quantity of the dish is more than 0, then add it to the selctedDishes array.f
        for dish in dishList_ {
            if (dish.dishQnty_ > 0) {
                selectedDishes_.append(dish)
            }
        }

        print("These are the selected dishes:")
        for dish in selectedDishes_ {
            print(dish.dishName_, " ",dish.dishQnty_)
        }
    }
    
    // Fetches data from database.
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dishes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {

                // Store the data in temporary variable.
                let tempDish = DishObject(dishID: data.value(forKey: "dishID") as! Int, dishName: data.value(forKey: "dishName") as! String, dishPrice: data.value(forKey: "dishPrice") as! Int, dishDesc: data.value(forKey: "dishDesc") as! String, dishImage: data.value(forKey: "dishImage") as! Data, dishCategory: data.value(forKey: "dishCategory") as! String, dishQnty: 0)
                
                // Insert the dishes name into the array.
                dishList_.append(tempDish)
                
            }
        } catch {
            print("failed!")
        }
    }
    
}

// Delegate function which is called whenever dish quanitiy is changed.
extension MenuViewController: CustomCellUpdater {
    func updateTableView(index: Int, quantity: Int) {
        dishList_[index].dishQnty_ = quantity
        checkSelectedDishes()
        print("Delegate executed")
    }
}
