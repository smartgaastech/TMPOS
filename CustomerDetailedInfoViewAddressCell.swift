//
//  CustomerDetailedInfoAddressViewCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewAddressCell: CustomerDetailedViewCell {
    
    class var expandedHeight : CGFloat {get{return 300}}
    class var defaultHeight : CGFloat{get{return 40}}
    
    @IBOutlet weak var txtCuRegionBox: UITextField!
    @IBOutlet weak var txtCuAdd1Box: UITextField!
    @IBOutlet weak var txtCuAdd2Box: UITextField!
    @IBOutlet weak var txtCuAdd3Box: UITextField!
    @IBOutlet weak var txtCuAdd4Box: UITextField!
    @IBOutlet weak var txtCuCountryBox: UITextField!
    @IBOutlet weak var txtCuAdd5Box: UITextField!
    @IBOutlet weak var txtCuPOBoxBox: UITextField!
    @IBOutlet weak var txtCuCityBox: UITextField!
    
    var customerInfo : NSMutableDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtCuRegionBox.isEnabled = false
        txtCuAdd1Box.isEnabled = false
        txtCuAdd2Box.isEnabled = false
        txtCuAdd3Box.isEnabled = false
        txtCuAdd4Box.isEnabled = false
        txtCuAdd5Box.isEnabled = false
        txtCuPOBoxBox.isEnabled = false
        txtCuCityBox.isEnabled = false
        txtCuCountryBox.isEnabled = false
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func fillData() {
        if let val = customerInfo?.value(forKey: Constants.PM_REGION) {
            txtCuRegionBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ADDRESS_1) {
            txtCuAdd1Box.text =  val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ADDRESS_2) {
            txtCuAdd2Box.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ADDRESS_3) {
            txtCuAdd3Box.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ADDRESS_4) {
            txtCuAdd4Box.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ADDRESS_5) {
            txtCuAdd5Box.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_COUNTRY) {
            txtCuCountryBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_ZIPCODE) {
            txtCuPOBoxBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_CITY) {
            txtCuCityBox.text = val as? String
        }
    }
    override func validateData(_ validationResult: NSMutableDictionary) {
        
    }
    override func getData(_ customerModel: NSMutableDictionary) {
        if let val = txtCuRegionBox.text {
            customerModel.setValue(val, forKey: Constants.PM_REGION)
        }
        if let val = txtCuAdd1Box.text {
            customerModel.setValue(val, forKey: Constants.PM_ADDRESS_1)
        }
        
        if let val = txtCuAdd2Box.text {
            customerModel.setValue(val, forKey: Constants.PM_ADDRESS_2)
        }
        if let val = txtCuAdd3Box.text {
            customerModel.setValue(val, forKey: Constants.PM_ADDRESS_3)
        }
        
        if let val = txtCuAdd4Box.text {
            customerModel.setValue(val, forKey: Constants.PM_ADDRESS_4)
        }
        if let val = txtCuAdd5Box.text {
            customerModel.setValue(val , forKey: Constants.PM_ADDRESS_5)
        }
        
        if let val = txtCuCountryBox.text {
            customerModel.setValue(val, forKey: Constants.PM_COUNTER_CODE)
        }
        if let val = txtCuPOBoxBox.text {
            customerModel.setValue(val, forKey: Constants.PM_ZIPCODE)
        }
        
        if let val = txtCuCityBox.text {
            customerModel.setValue(val, forKey: Constants.PM_CITY)
        }
    }

}
