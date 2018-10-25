//
//  CustomCell.swift
//  GTAlertCollectionDemo
//
//  Created by Gabriel Theodoropoulos on 22/10/2018.
//  Copyright © 2018 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


