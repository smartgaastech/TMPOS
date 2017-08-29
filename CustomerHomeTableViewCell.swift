//
//  CustomerHomeTableViewCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/5/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHomeTableViewCell: UITableViewCell {


    
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblCuGender: UILabel!    
    @IBOutlet weak var lblCuDob: UILabel!
    @IBOutlet weak var lblCuNo: UILabel!
    
    @IBOutlet weak var btnAvatar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
