//
//  ViewDishListController.swift
//  ServeLikeProV3
//
//  Created by mahi on 9/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class ViewDishListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dishTable_: UITableView!
    // Data model: These strings will be the data for the table view cells
    var dishList_ = [DishObject] ()
    var selectedDish_: DishObject?
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "customCell"
    
    // don't forget to hook this up from the storyboard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        dishTable_.delegate = self
        dishTable_.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishList_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishTable_.dequeueReusableCell(withIdentifier: "customCell", for: indexPath as IndexPath) as! CustomCell
        
        cell.dishImage_.image = UIImage(data:dishList_[indexPath.row].dishImage_,scale:1.0)
        cell.dishName_.text = dishList_[indexPath.row].dishName_
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDish_ = dishList_[indexPath.row]
        
        performSegue(withIdentifier: "dishSeague", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dishSeague") {
            let destinationController = segue.destination as! AddDish
            destinationController.selectedDish_ = self.selectedDish_
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
                
//                 Here are the debugging sentences.
                var temp = DishObject(dishID: data.value(forKey: "dishID") as! Int, dishName: data.value(forKey: "dishName") as! String, dishImage: data.value(forKey: "dishImage") as! Data, dishDesc: data.value(forKey: "dishDesc") as! String)
                                
                print("Name: ", temp.dishName_)
                print("ID", temp.dishID_)
                print("Desc: ", temp.dishDesc_)
                print("This is the pbject id: ", data.objectID)
                
                if (temp.dishImage_ != nil) {
                    print("Image found!")
                }
                
                // Insert the dishes name into the array.
                dishList_.append(temp)

            }
        } catch {
            print("failed!")
        }
    }
}
