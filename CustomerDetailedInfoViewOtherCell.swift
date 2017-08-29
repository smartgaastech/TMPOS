//
//  CustomerDetailedInfoViewOtherCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewOtherCell: CustomerDetailedViewCell {
    
    class var expandedHeight : CGFloat {get{return 250}}
    class var defaultHeight : CGFloat{get{return 40}}
    
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var txtRemarksBox: UITextView!
    @IBOutlet weak var txtCuNotesBox: UITextView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtRemarksBox.isEditable = false
        txtCuNotesBox.isEditable = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func fillData() {
        if let val = customerInfo.value(forKey: Constants.PM_REMARKS) {
            txtRemarksBox.text = val as? String
        }
        if let val = customerInfo.value(forKey: Constants.PM_NOTES) {
            txtCuNotesBox.text = val as? String
        }
    }
    override func validateData(_ validationResult: NSMutableDictionary) {
        
    }
    override func getData(_ customerModel: NSMutableDictionary) {
        if let val = txtRemarksBox.text {
            customerModel.setValue(val, forKey: Constants.PM_REMARKS)
        }
        if let val = txtCuNotesBox.text {
            customerModel.setValue(val, forKey: Constants.PM_NOTES)
        }        
    }
}
