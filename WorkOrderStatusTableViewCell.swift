//
//  WorkOrderStatusTableViewCell.swift
//  TouchymPOS
//
//  Created by ESHACK on 11/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblWorkOrderStatus: UILabel!
    @IBOutlet weak var lblWorkOrderDate: UILabel!
    @IBOutlet weak var lblWorkOrderNo: UILabel!
    
    @IBOutlet weak var lblWorkOrderCreated: UILabel!
    @IBOutlet weak var lblWorkOrderLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
