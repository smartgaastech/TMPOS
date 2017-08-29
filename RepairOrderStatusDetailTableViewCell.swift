//
//  RepairOrderStatusDetailTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 8/1/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderStatusDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var lblRepairOrderCreatedBy: UILabel!
    @IBOutlet weak var lblRepairOrderStatus: UILabel!
    @IBOutlet weak var lblRepairOrderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
