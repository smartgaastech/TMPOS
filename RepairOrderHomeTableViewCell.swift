//
//  RepairOrderHomeTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 7/25/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRepairOrderDate: UILabel!
    @IBOutlet weak var lblRepairOrderNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCustomerNo: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
