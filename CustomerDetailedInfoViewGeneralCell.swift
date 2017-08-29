//
//  CustomerDetailedInfoViewCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewGeneralCell: CustomerDetailedViewCell {
    
    
    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var txtCuOccupationBox: UITextField!
    @IBOutlet weak var txtCuNationalityBox: UITextField!
    @IBOutlet weak var txtCuCreatedByBox: UITextField!
    @IBOutlet weak var txtCuCompanyBox: UITextField!
    @IBOutlet weak var txtCuLocationBox: UILabel!
    @IBOutlet weak var txtCuDateOfBirthBox: UITextField!
    @IBOutlet weak var txtCuGenderBox: UITextField!
    @IBOutlet weak var txtCuNameBox: UITextField!
    @IBOutlet weak var txtCuNoBox: UILabel!
    
    @IBOutlet weak var uiswitchCuSubscribe: UISwitch!
    @IBOutlet weak var uiswitchCuFreeze: UISwitch!
    class var expandedHeight : CGFloat {get{return 350}}
    class var defaultHeight : CGFloat{get{return 40}}
    
    var customerInfo : NSMutableDictionary?
    var parent : UIViewController!
    
    var searchType = ""
    var searchTxtBox : UITextField!
    let adminModel = AdminSettingModel.getInstance()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtCuCreatedByBox.delegate = self
        txtCuCreatedByBox.addTarget(self, action: "txtFieldTouchInside", for: UIControlEvents.touchUpInside)
        
        txtCuOccupationBox.isEnabled = false
        txtCuNationalityBox.isEnabled = false
        txtCuCreatedByBox.isEnabled = false
        txtCuCompanyBox.isEnabled = false
        txtCuLocationBox.isEnabled = false
        txtCuDateOfBirthBox.isEnabled = false
        txtCuGenderBox.isEnabled = false
        txtCuNameBox.isEnabled = false
        uiswitchCuFreeze.isEnabled=false
        uiswitchCuSubscribe.isEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func checkWeight() {
        CellView.isHidden = (frame.size.height < CustomerDetailedInfoViewGeneralCell.expandedHeight)
    }
    
    override func fillData() {
        if let val = customerInfo?.value(forKey: Constants.PM_PATIENT_NAME) {
            txtCuNameBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_OCCUPATION) {
            txtCuOccupationBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_NATIONALITY) {
            txtCuNationalityBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_SM_CODE) {
            txtCuCreatedByBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_COMPANY) {
            txtCuCompanyBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_LOCN_CODE) {
            txtCuLocationBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_DOB) {
            let dobStr = customerInfo?.value(forKey: Constants.PM_DOB) as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtCuDateOfBirthBox.text = dateFormatter.string(from: date!)
        }
        if let val = customerInfo?.value(forKey: Constants.PM_GENDER) {
            txtCuGenderBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_CUST_NO) {
            txtCuNoBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_FRZ_FLAG_NUM){
            print(String(describing: val))
            if (String(describing: val) == "2") {
                uiswitchCuFreeze.isOn = true
            }else {
                uiswitchCuFreeze.isOn = false
            }
        }
        if let val = customerInfo?.value(forKey: Constants.PM_FLEX_20){
            if (String(describing: val) == "No") {
                uiswitchCuSubscribe.isOn = false
            }else {
                uiswitchCuSubscribe.isOn = true
            }
        }
    }
    
    override func validateData(_ validationResult: NSMutableDictionary) {
        
    }
    
    override func getData(_ customerModel: NSMutableDictionary) {
        if let val = txtCuNameBox.text {
            customerModel.setValue(val, forKey: Constants.PM_PATIENT_NAME)
        }
        if let val = txtCuOccupationBox.text {
            customerModel.setValue(val, forKey: Constants.PM_OCCUPATION)
        }
        
        if let val = txtCuNationalityBox.text {
            customerModel.setValue(val, forKey: Constants.PM_NATIONALITY)
        }
        if let val = txtCuCreatedByBox.text {
            customerModel.setValue(val, forKey: Constants.PM_SM_CODE)
        }
        
        if let val = txtCuCompanyBox.text {
            customerModel.setValue(val, forKey: Constants.PM_COMPANY)
        }
        if let val = txtCuLocationBox.text {
            customerModel.setValue(val , forKey: Constants.PM_LOCN_CODE)
        }
        
        if let val = txtCuDateOfBirthBox.text {
            customerModel.setValue(val, forKey: Constants.PM_DOB)
        }
        if let val = txtCuGenderBox.text {
            customerModel.setValue(val, forKey: Constants.PM_GENDER)
        }
        
        if let val = txtCuNoBox.text {
            customerModel.setValue(val, forKey: Constants.PM_CUST_NO)
        }
    }
    
}
