import UIKit

struct OrderObject {
    var staffID_: Int
    var tableNumber_: Int
    var orderID_: Int
    var selectedDishes_ = [DishObject] ()
    var totalCost_: Int = 0
    
    init(staffID: Int, tableNumber: Int, orderID: Int, selectedDishes: [DishObject]) {
        staffID_ = staffID
        tableNumber_ = tableNumber
        orderID_ = orderID
        selectedDishes_ = selectedDishes
        
        // Calculate total cost.
        for dish in selectedDishes_ {
            totalCost_ += dish.dishPrice_ * dish.dishQnty_
        }
    }
}
