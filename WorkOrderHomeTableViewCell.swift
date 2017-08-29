//
//  WorkOrderHomeTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 11/4/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderHomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblCustomerNo: UILabel!
    @IBOutlet weak var lblWorkOrderNo: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblWorkOrderDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}



