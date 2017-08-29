//
//  StockQueryLocationWiseTableCell.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 8/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryLocationWiseTableCell: UITableViewCell {

    
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var locationCode: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var price2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
