//
//  DishObject.swift
//  ServeLikeProV3
//
//  Created by mahi on 10/10/19.
//  Copyright © 2019 mad. All rights reserved.
//
import Foundation

public class DishObject: NSObject, NSCoding {
    var dishName_: String = ""
    var dishID_: Int = 0
    var dishPrice_: Int = 0
    var dishDesc_: String = "No Desciption available."
    var dishImage_: Data!
    var dishCategory_: String = ""
    var dishQnty_: Int = 0
    
    override init() {
        super.init()
    }
    
    init(dishID: Int, dishName: String) {
        self.dishID_ = dishID
        self.dishName_ = dishName
    }
    
    init(dishID: Int, dishName: String, dishQnty: Int) {
        self.dishID_ = dishID
        self.dishName_ = dishName
        self.dishQnty_ = dishQnty
    }
    
    init(dishID: Int, dishName: String, dishImage: Data, dishDesc: String) {
        self.dishID_ = dishID
        self.dishName_ = dishName
        self.dishImage_ = dishImage
        self.dishDesc_ = dishDesc
    }
    
    init(dishID: Int, dishName: String, dishPrice: Int, dishDesc: String, dishImage: Data, dishCategory: String, dishQnty: Int) {
        dishName_ = dishName
        dishID_ = dishID
        dishPrice_ = dishPrice
        dishCategory_ = dishCategory
        dishImage_ = dishImage
        dishDesc_ = dishDesc
        dishQnty_ = dishQnty
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(dishName_, forKey: "dishName_")
        aCoder.encode(dishID_, forKey: "dishID_")
        aCoder.encode(dishPrice_, forKey: "dishPrice_")
        aCoder.encode(dishCategory_, forKey: "dishCategory_")
        aCoder.encode(dishImage_, forKey: "dishImage_")
        aCoder.encode(dishDesc_, forKey: "dishDesc_")
        aCoder.encode(dishQnty_, forKey: "dishQnty_")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let dishName = aDecoder.decodeObject(forKey: "dishName_")
        let dishID = aDecoder.decodeInt32(forKey: "dishID_")
        let dishPrice = aDecoder.decodeInt32(forKey: "dishPrice_")
        let dishCategory = aDecoder.decodeObject(forKey: "dishCategory_")
        let dishImage = aDecoder.decodeObject(forKey: "dishImage_")
        let dishDesc = aDecoder.decodeObject(forKey: "dishDesc_")
        let dishQnty = aDecoder.decodeInt32(forKey: "dishQnty_")
        
        self.init(dishID: Int(dishID), dishName: dishName as! String, dishPrice: Int(dishPrice), dishDesc: dishDesc as! String, dishImage: dishImage as! Data, dishCategory: dishCategory as! String, dishQnty: Int(dishQnty))
    }
}
