//
//  AddDish.swift
//  ServeLikeProV3
//
//  Created by mahi on 9/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddDish: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var dishIndex:Int = 0;
    
    var selectedDish_: DishObject?
    var selectedCategory_: String?
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var nameTextField_: UITextField!
    @IBOutlet weak var priceTextField_: UITextField!
    @IBOutlet weak var descTextField_: UITextView!
    @IBOutlet weak var selectImageButton_: UIButton!
    @IBOutlet weak var imageView_: UIImageView!
    @IBOutlet weak var saveButton_: UIBarButtonItem!
    @IBOutlet weak var dishCategoryPicker_: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (selectedDish_ != nil) {
            print("Data has been received here!")
            nameTextField_.text = selectedDish_?.dishName_
            priceTextField_.text = String(selectedDish_!.dishPrice_)
            imageView_.image = UIImage(data: selectedDish_!.dishImage_,scale:1.0)
            descTextField_.text = selectedDish_?.dishDesc_
            print("ID: ", selectedDish_?.dishID_)
        }
        
        imagePicker.delegate = self
        
        dishCategoryPicker_.delegate = self
        dishCategoryPicker_.dataSource = self
    }
    
    @IBAction func addDish(_ sender: Any) {
        if (checkFormValidity() == true) {
            if (selectedDish_ == nil) {
                saveData()
            }
            else {
                updateData()
            }
        }
        else {
            print("Data not being saved!")
        }
        print(selectedCategory_)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // *************************** PICKER VIEW FUNCTIONS START ***************************
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        return utilityClass.dishCategory.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return utilityClass.dishCategory[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory_ = utilityClass.dishCategory[row]
        print(selectedCategory_!)
    }
    
    // *************************** PICKER VIEW FUNCTIONS END ***************************
    
    func saveData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dishes", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        // Here we process the image.
        let imageData = utilityClass.imageToData(image: imageView_.image!)
        
        newEntity.setValue(descTextField_.text, forKey: "dishDesc");
        newEntity.setValue(utilityClass.dishIndex, forKey: "dishID");
        newEntity.setValue(imageData, forKey: "dishImage");
        newEntity.setValue(nameTextField_.text, forKey: "dishName");
        newEntity.setValue(selectedCategory_!, forKey: "dishCategory");
        newEntity.setValue(Int(priceTextField_.text!), forKey: "dishPrice");
        
        do {
            try context.save()
            print("saved")
            utilityClass.dishIndex += 1
            // Sending Alert to the user.
            let alert = UIAlertController(title: "Success!", message: "Added new dish to the menu!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            AddDish.dishIndex += 1;
        } catch {
            print("Failed adding new Dish!")
        }
    }
    
    func updateData() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dishes", in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(dishID == %i)", selectedDish_!.dishID_)
        request.predicate = predicate
        do {
            var results =
                try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue(nameTextField_.text!, forKey: "dishName")
//            objectUpdate.setValue(Int(priceTextField_.text!, forKey: "dishPrice"))
            objectUpdate.setValue(descTextField_.text!, forKey: "dishDesc")

            do {
                try managedContext.save()
                print("Successfully Updated")
            }catch let error as NSError {
                print(error.localizedFailureReason!)
            }
        }
        catch let error as NSError {
            print(error.localizedFailureReason!)
        }
    }
    
    func deleteData(id: Int) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dishes", in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(dishID == %i)", selectedDish_!.dishID_)
        request.predicate = predicate
        do {
            var results =
                try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            
            do {
                try managedContext.delete(objectUpdate)
                print("Successfully deleted")
//                let alert = UIAlertController(title: "Alert", message: "Successfully deleted!", preferredStyle: .alert)
//                self.present(alert, animated: true, completion: nil)
            }catch let error as NSError {
                print(error.localizedFailureReason!)
            }
        }
        catch let error as NSError {
            print(error.localizedFailureReason!)
        }
    }
    
    func checkFormValidity()->Bool {
        var isValid: Bool = true
        if (nameTextField_.text == "") {
            isValid = false
            nameTextField_.layer.borderWidth = 1
            nameTextField_.layer.borderColor = UIColor.red.cgColor
        }
        else {
                nameTextField_.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if (priceTextField_.text == "") {
            isValid = false
            priceTextField_.layer.borderWidth = 1
            priceTextField_.layer.borderColor = UIColor.red.cgColor
        }
        else {
            priceTextField_.layer.borderColor = UIColor.lightGray.cgColor

        }
        return isValid
    }
    
    // When delete button is pressed.
    @IBAction func onClickDelete(_ sender: Any) {
        deleteData(id: selectedDish_!.dishID_)
        performSegue(withIdentifier: "dishToDishListSegue", sender: self)
    }
    
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")
            
 
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView_.image = pickedImage
        }
        dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dishToDishListSegue") {
            let destinationController = segue.destination as! ViewDishListController
        }
    }
}
