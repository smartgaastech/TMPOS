//
//  WorkOrderStatusDetailTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 12/1/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderStatusDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblWorkOrderDate: UILabel!
    @IBOutlet weak var lblWorkOrderCreatedBy: UILabel!
    
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var lblWorkOrderStatus: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
