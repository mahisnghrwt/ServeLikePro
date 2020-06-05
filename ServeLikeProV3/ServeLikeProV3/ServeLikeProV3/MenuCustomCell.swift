//
//  MenuCustomCell.swift
//  ServeLikeProV3
//
//  Created by mahi on 11/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import UIKit

protocol CustomCellUpdater: MenuViewController {
    func updateTableView(index: Int, quantity: Int)
}

class MenuCustomCell: UITableViewCell {
    
    @IBOutlet weak var dishImage_: UIImageView!
    @IBOutlet weak var dishName_: UILabel!
    @IBOutlet weak var dishDesc_: UITextView!
    @IBOutlet weak var dishQuantity_: UILabel!
    @IBOutlet weak var dishQuantityStepper_: UIStepper!
    @IBOutlet weak var removeDishButton_: UIButton!
    
    var index_: Int?
    
    // Delegate, to update table view.
    weak var delegate: CustomCellUpdater?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        removeDishButton_.isHidden = true
        
        dishQuantityStepper_.wraps = true
        dishQuantityStepper_.minimumValue = 0.0
        dishQuantityStepper_.maximumValue = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Executes whenever Stepper is used, and changes the value of the quantityLabel
    // accordingly.
    @IBAction func stepperUsed(_ sender: UIStepper) {
        self.dishQuantity_.text = String(Int(sender.value))
        checkQuantity()
        delegate?.updateTableView(index: index_!, quantity: Int(sender.value))
        
    }
    
    // Deselect the dish.
    @IBAction func removDish(_ sender: Any) {
        self.dishQuantity_.text = String(0)
        checkQuantity()
        delegate?.updateTableView(index: index_!, quantity: 0)
        print("Remove vutton is executing")
    }
    
    func checkQuantity() {
        if (Int(dishQuantity_.text!)! > 0) {
            removeDishButton_.isHidden = false
            dishQuantity_.textColor = utilityClass.greenColor
        }
        else {
            removeDishButton_.isHidden = true
            dishQuantity_.textColor = UIColor.black
        }
    }
}

