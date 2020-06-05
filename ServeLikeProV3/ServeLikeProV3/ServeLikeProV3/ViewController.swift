//
//  ViewController.swift
//  ServeLikeProV3
//
//  Created by mahi on 9/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        utilityClass.updatePrimaryKey()
        print("Dish index:\t", utilityClass.dishIndex)
    }

    @IBAction func callClearData(_ sender: Any) {
        utilityClass.clearData(tableName: utilityClass.dishTable)
    }
    
    @IBAction func clearOrdersTable(_ sender: Any) {
        utilityClass.clearData(tableName: utilityClass.orderTable)
    }
}

