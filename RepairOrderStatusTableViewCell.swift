//
//  RepairOrderStatusTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 7/30/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderStatusTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblROStatus: UILabel!
    
    @IBOutlet weak var lblROCreatedBy: UILabel!
    @IBOutlet weak var lblROLocation: UILabel!
    @IBOutlet weak var lblRONumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
