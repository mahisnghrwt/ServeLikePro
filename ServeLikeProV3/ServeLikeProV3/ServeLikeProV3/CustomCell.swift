//
//  CustomCell.swift
//  ServeLikeProV3
//
//  Created by mahi on 11/10/19.
//  Copyright © 2019 mad. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var dishImage_: UIImageView!
    @IBOutlet weak var dishName_: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
