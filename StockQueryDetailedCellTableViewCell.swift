//
//  StockQueryDetailedCellTableViewCell.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 5/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryDetailedCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBarCode: UILabel!
    @IBOutlet weak var lblGradeCode: UILabel!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
