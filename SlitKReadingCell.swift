//
//  SlitKReadingCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/16/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class SlitKReadingCell: UITableViewCell {


    @IBOutlet weak var lblCompanyCode: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocationCode: UILabel!
    @IBOutlet weak var lblOptimetric: UILabel!
    
    var slitKReadingData :NSMutableDictionary = NSMutableDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillData() {
        if let val = slitKReadingData.value(forKey: Constants.PRXSKR_COMP_CODE) {
            lblCompanyCode.text = val as? String
        }
        if let val = slitKReadingData.value(forKey: Constants.PRXSKR_DATE) {
            var dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            lblDate.text =  dateFormatter.string(from: date!)
        }
        if let val = slitKReadingData.value(forKey: Constants.PRXSKR_LOCN_CODE) {
            lblLocationCode.text = val as? String
        }
        if let val = slitKReadingData.value(forKey: Constants.PRXSKR_SM_CODE) {
            lblOptimetric.text = val as? String
        }
    }

}
