//
//  utilityClass.swift
//  ServeLikeProV3
//
//  Created by mahi on 12/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct DashboardObject {
    var thumbnail_: UIImage
    var label_: String
    
    init(label: String, thumbnail: UIImage) {
        label_ = label
        thumbnail_ = thumbnail
    }
}

class utilityClass {
    static var dishIndex: Int = 0
//    let redColor = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    static let dishCategory: [String] = ["Entrees", "Mains", "Desserts"]
    
    static let staff: [String] = ["James", "Posty", "Adam Levine", "Bazzi", "Pitbull"]
    
    static let staffTable = [staff, ["1", "2", "3", "4", "5", "6"]]
    
    static let dishTable: String = "Dishes"
    
    static let orderTable: String = "Orders"
    
    static let greenColor = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 96.0/255.0, alpha: 1.0)

    static func imageToData (image: UIImage) -> Data {
        let imageData = image.jpegData(compressionQuality: 1.0)
        return imageData!
    }
    
    static func clearData(tableName: String) {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
            print("Entity ", tableName, "has been cleared!")
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    // Fetches data from database.
    static func updatePrimaryKey() {
        self.dishIndex = 0
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dishes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "dishID") as! Int > utilityClass.dishIndex) {
                    self.dishIndex = data.value(forKey: "dishID") as! Int
                }
                
            }
        } catch {
            print("failed!")
        }
        
        // Increment the value of dishIndex by 1.
        self.dishIndex += 1
    }
    
    // Fetches data from database.
    static func getData()-> Array<DishObject> {
        var dishList_ = [DishObject] ()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dishes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                //                 Here are the debugging sentences.
                var temp = DishObject(dishID: data.value(forKey: "dishID") as! Int, dishName: data.value(forKey: "dishName") as! String, dishImage: data.value(forKey: "dishImage") as! Data, dishDesc: data.value(forKey: "dishDesc") as! String)
                
                //                let temp = DishObject(dishID: data.value(forKey: "dishID") as! Int, dishName: data.value(forKey: "dishName") as! String, dishPrice: data.value(forKey: "dishPrice") as! Int, dishDesc: data.value(forKey: "dishDesc") as! String, dishImage: data.value(forKey: "dishImage") as! Data, dishCategory: data.value(forKey: "dishCategory") as! String)
                
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
        return dishList_
    }
}
