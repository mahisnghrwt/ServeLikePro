//
//  ConfirmOrderViewController.swift
//  ServeLikeProV3
//
//  Created by mahi on 14/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MessageUI

class confirmOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    
    var totalCost: Int = 0
    var msg: String = ""
    var selectedDishes_ = [DishObject] ()
    @IBOutlet weak var selectedDishesTableView_: UITableView!
    @IBOutlet weak var totalCostLabel_: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDishesTableView_.delegate = self
        selectedDishesTableView_.dataSource = self
        
        composeMessageBody()
        
        totalCostLabel_.text = String(totalCost)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDishes_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedDishesTableView_.dequeueReusableCell(withIdentifier: "ConfirmOrderCustomCell", for: indexPath as IndexPath) as! UITableViewCell
        
        cell.textLabel!.text = selectedDishes_[indexPath.row].dishName_
        print(selectedDishes_[indexPath.row].dishPrice_, "----")
        return cell
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "confirmToTakeOrderSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmToTakeOrderSegue") {
            let destinationController = segue.destination as! TakeOrderViewController
            destinationController.selectedDishes_ = self.selectedDishes_
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = msg
            controller.recipients = ["0450795734"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            print("MSG func is working")
        }
        else {
            print("MSG func is not working")
        }
        
        saveData()
        fetchData()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
            case .cancelled:
                print("Message was cancelled")
                dismiss(animated: true, completion: nil)
            case .failed:
                print("Message failed")
                dismiss(animated: true, completion: nil)
            case .sent:
                print("Message was sent")
                dismiss(animated: true, completion: nil)
            default:
                break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func composeMessageBody() {
        for dish in selectedDishes_ {
            msg += dish.dishName_ + " - " + String(dish.dishQnty_) + ",\n"
            totalCost += dish.dishPrice_ * dish.dishQnty_
        }
        msg += "Total cost: " + String(totalCost)
    }
    
    func saveData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Orders", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(0, forKey: "staffID");
        newEntity.setValue(selectedDishes_, forKey: "dish");
        newEntity.setValue(1, forKey: "orderID");
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("Failed adding new Dish!")
        }
    }
    
    // Fetches data from database.
    func fetchData(){
//        var dishes = [DishObject] ()
        var orderID: Int
        var staffID: Int
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Orders")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                staffID = (data.value(forKey: "staffID") as? Int)!
                orderID = (data.value(forKey: "orderID") as? Int)!
                let dishes = (data.value(forKey: "dish") as? [DishObject])!
                
                
                print("Staff: ", String(staffID))
                print("Order", String(orderID))
                for dish in dishes {
                    print(dish.dishName_, ", ")
                }
                
            }
        } catch {
            print("Error occurred while fetching data!")
        }
    }
    
}
