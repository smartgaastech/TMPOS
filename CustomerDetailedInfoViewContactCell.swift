//
//  CustomerDetailedInfoViewContectCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewContactCell: CustomerDetailedViewCell {
    
    class var expandedHeight : CGFloat {get{return 150}}
    class var defaultHeight : CGFloat{get{return 40}}
    
    @IBOutlet weak var txtCuMobBox: UITextField!
    @IBOutlet weak var txtCUTelNoBox: UITextField!
    @IBOutlet weak var txtCuTelResBox: UITextField!
    @IBOutlet weak var txtCuEmailBox: UITextField!
    
    
    var customerInfo : NSMutableDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtCuMobBox.isEnabled = false
        txtCuTelResBox.isEnabled = false
        txtCUTelNoBox.isEnabled = false
        txtCuEmailBox.isEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func fillData() {        
        if let val = customerInfo?.value(forKey: Constants.PM_TEL_MOB) {
        txtCuMobBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_TEL_OFF) {
        txtCUTelNoBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_TEL_RES) {
        txtCuTelResBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_EMAIL) {
        txtCuEmailBox.text = val as? String
        }
    }
    override func validateData(_ validationResult: NSMutableDictionary) {
        
    }
    override func getData(_ customerModel: NSMutableDictionary) {
        if let val = txtCuMobBox.text {
            customerModel.setValue(val, forKey: Constants.PM_TEL_MOB)
        }
        if let val = txtCUTelNoBox.text {
            customerModel.setValue(val, forKey: Constants.PM_TEL_OFF)
        }
        
        if let val = txtCuTelResBox.text {
            customerModel.setValue(val, forKey: Constants.PM_TEL_RES)
        }
        if let val = txtCuEmailBox.text {
            customerModel.setValue(val, forKey: Constants.PM_EMAIL)
        }
    }
}
