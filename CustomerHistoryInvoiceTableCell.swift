//
//  CustomerHistoryInvoiceTableCell.swift
//  TouchymPOS
//
//  Created by XCodeClub on 2016-05-04.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistoryInvoiceTableCell: UITableViewCell {
    
    
    @IBOutlet weak var lblIteamCode: UILabel!

    @IBOutlet weak var lblIteamUom: UILabel!
    @IBOutlet weak var lblIteamName: UILabel!
    
    @IBOutlet weak var lblIteamAmount: UILabel!
    @IBOutlet weak var lblIteamQty: UILabel!
    @IBOutlet weak var lblIteamRate: UILabel!
    @IBOutlet weak var lblIteamDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
