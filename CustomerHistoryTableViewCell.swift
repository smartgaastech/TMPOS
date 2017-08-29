//
//  customerHistoryCellTableViewCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/14/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblPvComCode: UILabel!
    @IBOutlet weak var lblPVLocationCode: UILabel!
    @IBOutlet weak var lblPvSalseOrderNo: UILabel!
    @IBOutlet weak var lblPvInvoiceNo: UILabel!
    @IBOutlet weak var lblPvDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
