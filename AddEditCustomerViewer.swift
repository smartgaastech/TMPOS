//
//  AddEditCustomerViewer.swift
//  TouchymPOS
//
//  Created by user115796 on 4/19/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class AddEditCustomerViewer: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var operationType : String!
    var parentViewer : UIViewController!
    let adminModel = AdminSettingModel.getInstance()
    var customerInfo : NSMutableDictionary!
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    let protocolUpdater = NSMutableDictionary()
    var countryISDCodes = NSMutableDictionary()
    var countrySelected = false
    
    var currentTextField : UITextField!
    var currentTextView : UITextView!
    var movedYOrigin : CGFloat!
    
    
    @IBOutlet weak var buttonSelectGender: UIButton!
    @IBOutlet weak var buttonSelectDate: UIButton!
    @IBOutlet weak var buttonSelectCreatedBy: UIButton!
    
    @IBOutlet weak var txtCuOccupationBox: UITextField!
    @IBOutlet weak var txtCuNationalityBox: UITextField!
    @IBOutlet weak var txtCuCreatedByBox: UITextField!
    @IBOutlet weak var txtCuCompanyBox: UITextField!
    @IBOutlet weak var txtCuLocationBox: UILabel!
    @IBOutlet weak var txtCuDateOfBirthBox: UITextField!
    @IBOutlet weak var txtCuGenderBox: UITextField!
    @IBOutlet weak var txtCuNameBox: UITextField!
    @IBOutlet weak var txtCuNoBox: UILabel!
    @IBOutlet weak var txtCuRegionBox: UITextField!
    @IBOutlet weak var txtCuAdd1Box: UITextField!
    @IBOutlet weak var txtCuAdd2Box: UITextField!
    @IBOutlet weak var txtCuAdd3Box: UITextField!
    @IBOutlet weak var txtCuAdd4Box: UITextField!
    @IBOutlet weak var txtCuCountryBox: UITextField!
    @IBOutlet weak var txtCuAdd5Box: UITextField!
    @IBOutlet weak var txtCuPOBoxBox: UITextField!
    @IBOutlet weak var txtCuCityBox: UITextField!
    @IBOutlet weak var txtCuMobBox: UITextField!
    @IBOutlet weak var txtCUTelNoBox: UITextField!
    @IBOutlet weak var txtCuTelResBox: UITextField!
    @IBOutlet weak var txtCuEmailBox: UITextField!
    @IBOutlet weak var txtRemarksBox: UITextView!
    @IBOutlet weak var txtCuNotesBox: UITextView!
    
    @IBOutlet weak var uiswitchCuSubscribe: UISwitch!
    @IBOutlet weak var uiswitchCuFreeze: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 1400
       
        if operationType == Constants.OPERATION_TYPE_ADD {
            txtCuLocationBox.text = adminModel.userDataDic.value(forKey: Constants.LOCN_CODE) as? String
            txtCuCountryBox.text = "UAE"
            txtCuMobBox.text = "971"
        }
        
        txtCuCreatedByBox.addTarget(self, action: #selector(AddEditCustomerViewer.txtFieldTouchInside), for: UIControlEvents.touchDown)
        txtCuGenderBox.addTarget(self, action: #selector(AddEditCustomerViewer.txtfieldGenderTouchInside), for: UIControlEvents.touchDown)
        
        txtCuOccupationBox.delegate = self
        txtCuNationalityBox.delegate = self
        txtCuCreatedByBox.delegate = self
        txtCuCompanyBox.delegate = self
        txtCuDateOfBirthBox.delegate = self
        txtCuGenderBox.delegate = self
        txtCuNameBox.delegate = self
        txtCuRegionBox.delegate = self
        txtCuAdd1Box.delegate = self
        txtCuAdd2Box.delegate = self
        txtCuAdd3Box.delegate = self
        txtCuAdd4Box.delegate = self
        txtCuCountryBox.delegate = self
        txtCuAdd5Box.delegate = self
        txtCuPOBoxBox.delegate = self
        txtCuCityBox.delegate = self
        txtCuMobBox.delegate = self
        txtCUTelNoBox.delegate = self
        txtCuTelResBox.delegate = self
        txtCuEmailBox.delegate = self
        txtRemarksBox.delegate = self
        txtCuNotesBox.delegate = self
        fillData()
        //self.navigationController?.hidesBarsOnTap = true
    }
    
    @IBAction func txtCuCountryTouchDown(_ sender: Any) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_COUNTRY, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_COUNTRY)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_COUNTRY) as! NSMutableDictionary
            countryISDCodes = resDic.value(forKey: "ISDCodes") as! NSMutableDictionary
            countrySelected = true
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func txtCuCountryTouchUpInside(_ sender: Any) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_COUNTRY, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_COUNTRY)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_COUNTRY) as! NSMutableDictionary
            countryISDCodes = resDic.value(forKey: "ISDCodes") as! NSMutableDictionary
            countrySelected = true
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == Constants.FIELD_SHOULD_NOT_EDIT {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = protocolUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_COUNTRY) {
            txtCuCountryBox.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
            protocolUpdater.removeObject(forKey: Constants.LIST_VIEW_SEARCH_COUNTRY)
            var countryCodeval = txtCuCountryBox.text
            if let val = countryISDCodes.value(forKey: countryCodeval!) {
                txtCuMobBox.text = val as! String
            }
        }else if let val = protocolUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            txtCuCreatedByBox.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
    }  
    
    
    @IBAction func performSaveButtonAction(_ sender: UIBarButtonItem) {
        /* Step 1 : for loop get all the cells one by one
        Step 2 : Call validate method for each cell to do validation
        Step 3 : if validation successful then call for store
        */
        
        /*
        Step 1 : If there is no validation error or warnings then loop each cell and fill the data.
        */
        let cuModel = CustomerModel()
        if operationType == Constants.OPERATION_TYPE_ADD && customerInfo == nil {
            customerInfo = NSMutableDictionary()
        }
        //let dataDic = NSMutableDictionary()
        let adminDic = adminModel.userDataDic
        let countSetup = adminDic.value(forKey: Constants.COUNT_SETUP) as! NSDictionary
        
        if let val = txtCuNameBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter a value for - 'Name'")
                return
            }
        }
        if let val = txtCuCreatedByBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter a value for - 'Created By'")
                return
            }
        }
        if let val = txtCuDateOfBirthBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter a value for - 'Date of Birth'")
                return
            }
        }
        if let val = txtCuGenderBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter a value for - 'Gender'")
                return
            }
        }
        if let val = txtCuMobBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter a value for - 'Mobile'")
                return
            }
        }
        getValues(customerInfo)
        
        let controller  = CustomerHomeScreenController()
        
        if operationType == Constants.OPERATION_TYPE_ADD {
            customerInfo.setValue(adminDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.PM_COUNTER_CODE)
            customerInfo.setValue(countSetup.value(forKey: Constants.CUST_CODE), forKey: Constants.PM_CUST_CODE)
            customerInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PM_CR_UID)
            customerInfo.setValue(adminDic.value(forKey: Constants.COMP_CODE), forKey: Constants.PM_COMP_CODE)
            customerInfo.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.PM_LOCN_CODE)
            customerInfo.setValue("0", forKey: Constants.PM_SYS_ID)
            customerInfo.setValue("", forKey: Constants.PM_CUST_NO)
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            customerInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PM_UPD_UID)
        }
        
        cuModel.reqeustType.setValue(customerInfo, forKey: Constants.CU_SAVE_CUSTOMER_INFO)
        cuModel.reqeustType.setValue(operationType, forKey: Constants.OPERATION_TYPE)
        
        
        let cusMobileCheckModel: CustomerModel  = CustomerModel()
        cusMobileCheckModel.reqeustType.setObject(self.txtCuMobBox.text!, forKey: Constants.CU_SEARCH_BY_PHONE_NO as NSCopying)
        let resModel = controller.performSyncRequest(cusMobileCheckModel) as! CustomerModel
        let errorMsg = resModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) as? String
        if errorMsg == nil && self.operationType == Constants.OPERATION_TYPE_ADD {
            if resModel.responseResult.count > 0 {
                
                var refreshAlert = UIAlertController(title: "Warning!! Phone number already exists!!", message: "Do you want to proceed anyway?", preferredStyle: UIAlertControllerStyle.alert)
                //var height:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.25)
                //refreshAlert.view.addConstraint(height);
                //var width:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 0.80)
                //refreshAlert.view.addConstraint(width);
                var success = false
                refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
    
                    refreshAlert .dismiss(animated: true, completion: nil)
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                    let resCuModel = controller.performSaveOperation(cuModel) as! CustomerModel
                    var msgTitle :String!
                    if self.operationType == Constants.OPERATION_TYPE_ADD {
                        msgTitle = "Add Operation"
                    } else if self.operationType == Constants.OPERATION_TYPE_EDIT {
                        msgTitle = "Edit Operation"
                    } else {
                        msgTitle = "Delete Operation"
                    }
                    if resCuModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
                        self.customerInfo = resCuModel.responseResult.value(forKey: Constants.CU_SAVE_CUSTOMER_OBJ_NAME) as? NSMutableDictionary
                        if self.customerInfo != nil  && self.operationType == Constants.OPERATION_TYPE_ADD {
                            if let cuId = self.customerInfo?.value(forKey: Constants.PM_CUST_NO) as? String {
                                let cuHomeScreen = self.parentViewer as? CustomerHomeScreenViewer
                                cuHomeScreen?.searchResult.removeAllObjects()
                                cuHomeScreen?.searchResult.setValue(self.customerInfo, forKey: cuId)
                                cuHomeScreen?.searchkeyResult = cuHomeScreen?.searchResult.allKeys  as! [String]
                            }
                        } else if self.customerInfo != nil && self.operationType == Constants.OPERATION_TYPE_EDIT {
                            if let cuId = self.customerInfo?.value(forKey: Constants.PM_CUST_NO) as? String {
                                let cuHomeScreen = self.parentViewer as? CustomerDetailedInfoViewer
                                cuHomeScreen?.updateEditedDataObject(self.customerInfo)
                            }
                        }
                        let email = self.txtCuEmailBox.text
                        let trimedSt = email!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        var msg = ""
                        if trimedSt.isEmpty {
                            msg = "Email Id Not entered. However Customer \(self.operationType)ed Successfully"
                        } else {
                            msg = "Customer \(self.operationType)ed Successfully"
                        }
                        self.showErrorMsg(msgTitle, message: msg)
                    } else {
                        self.showErrorMsg(msgTitle, message: "Error while \(self.operationType)ing Customer.")
                    }
                    refreshAlert .dismiss(animated: true, completion: nil)
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
            
        } else {
           
            let resCuModel = controller.performSaveOperation(cuModel) as! CustomerModel
            var msgTitle :String!
            if operationType == Constants.OPERATION_TYPE_ADD {
                msgTitle = "Add Operation"
            } else if operationType == Constants.OPERATION_TYPE_EDIT {
                msgTitle = "Edit Operation"
            } else {
                msgTitle = "Delete Operation"
            }
        
            if resCuModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
            self.customerInfo = resCuModel.responseResult.value(forKey: Constants.CU_SAVE_CUSTOMER_OBJ_NAME) as? NSMutableDictionary
            if customerInfo != nil  && operationType == Constants.OPERATION_TYPE_ADD {
                if let cuId = customerInfo?.value(forKey: Constants.PM_CUST_NO) as? String {
                    let cuHomeScreen = parentViewer as? CustomerHomeScreenViewer
                    cuHomeScreen?.searchResult.removeAllObjects()
                    cuHomeScreen?.searchResult.setValue(customerInfo, forKey: cuId)
                    cuHomeScreen?.searchkeyResult = cuHomeScreen?.searchResult.allKeys  as! [String]
                }
            } else if customerInfo != nil && operationType == Constants.OPERATION_TYPE_EDIT {
                if let cuId = customerInfo?.value(forKey: Constants.PM_CUST_NO) as? String {
                    let cuHomeScreen = parentViewer as? CustomerDetailedInfoViewer
                    cuHomeScreen?.updateEditedDataObject(customerInfo)
                }
            }
            let email = txtCuEmailBox.text
            let trimedSt = email!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            var msg = ""
            if trimedSt.isEmpty {
                msg = "Email Id Not entered. However Customer \(operationType)ed Successfully"
            } else {
                msg = "Customer \(operationType)ed Successfully"
            }
            showErrorMsg(msgTitle, message: msg)
            } else {
                showErrorMsg(msgTitle, message: "Error while \(operationType)ing Customer.")
            }
        }
    }
    
    func showYesNoValidatorToSummarize(_ title: String, message: String)->Bool{
        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        var height:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.25)
        refreshAlert.view.addConstraint(height);
        var width:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 0.80)
        refreshAlert.view.addConstraint(width);
        var success = false
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
            success = false
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            success = true
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
    
        present(refreshAlert, animated: true, completion: nil)
        return success
    }
    
    func getValues(_ customerModel : NSMutableDictionary) {
        
        if let val = txtCuNameBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_PATIENT_NAME)
            //}
        }
        if let val = txtCuOccupationBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_OCCUPATION)
            //}
        }
        if uiswitchCuFreeze.isOn {
            var flag :NSObject!
            flag = 2 as NSObject!
            customerModel.setValue(flag, forKey: Constants.PM_FRZ_FLAG_NUM)
        }else {
            var flag :NSObject!
            flag = 1 as NSObject!
            customerModel.setValue(flag, forKey: Constants.PM_FRZ_FLAG_NUM)
        }
        
        if uiswitchCuSubscribe.isOn{
            customerModel.setValue("Yes", forKey: Constants.PM_FLEX_20)
        }else{
            customerModel.setValue("No", forKey: Constants.PM_FLEX_20)
        }
        
        if let val = txtCuNationalityBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_NATIONALITY)
            //}
        }
        if let val = txtCuCreatedByBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_SM_CODE)
            //}
        }
        
        if let val = txtCuCompanyBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_COMPANY)
            //}
        }
        
        if let val = txtCuLocationBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val , forKey: Constants.PM_LOCN_CODE)
            //}
        }
        
        if let val = txtCuDateOfBirthBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            customerModel.setValue(dateFormatter.string(from: date!) , forKey: Constants.PM_DOB)
            //}
        }
        if let val = txtCuGenderBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           // if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_GENDER)
            //}
        }
        
        if let val = txtCuNoBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_CUST_NO)
            //}
        }
        if let val = txtCuRegionBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_REGION)
            //}
        }
        if let val = txtCuAdd1Box.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_ADDRESS_1)
            //}
        }
        
        if let val = txtCuAdd2Box.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_ADDRESS_2)
            //}
        }
        if let val = txtCuAdd3Box.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_ADDRESS_3)
            //}
        }
        
        if let val = txtCuAdd4Box.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_ADDRESS_4)
            //}
        }
        if let val = txtCuAdd5Box.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val , forKey: Constants.PM_ADDRESS_5)
            //}
        }
        
        if let val = txtCuCountryBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_COUNTRY)
            //}
        }
        if let val = txtCuPOBoxBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_ZIPCODE)
            //}
        }
        
        if let val = txtCuCityBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_CITY)
            //}
        }
        if let val = txtCuMobBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           // if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_TEL_MOB)
            //}
        }
        if let val = txtCUTelNoBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_TEL_OFF)
            //}
        }
        
        if let val = txtCuTelResBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_TEL_RES)
            //}
        }
        if let val = txtCuEmailBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_EMAIL)
            //}
        }
        if let val = txtRemarksBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_REMARKS)
            //}
        }
        if let val = txtCuNotesBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                customerModel.setValue(val, forKey: Constants.PM_NOTES)
           // }
        }
    }
    func fillData() {
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
        if let val = customerInfo?.value(forKey: Constants.PM_FRZ_FLAG_NUM){
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
        if let val = customerInfo?.value(forKey: Constants.PM_LOCN_CODE) {
            txtCuLocationBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_DOB) {
            let dobStr = val as? String
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
        if let val = customerInfo?.value(forKey: Constants.PM_REMARKS) {
            txtRemarksBox.text = val as? String
        }
        if let val = customerInfo?.value(forKey: Constants.PM_NOTES) {
            txtCuNotesBox.text = val as? String
        }
    }
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*func txtFieldTouchInside(textfield : UITextField) {
        
        let tag = textfield.tag
        if textfield.tag != 3 {
            return
        }
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_SALES_MAN, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.valueForKey(Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.valueForKey(Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.valueForKey(Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.valueForKey(Constants.ERROR_RESPONSE) == nil) {
            let point = parent.view.center
            let frame = CGRect(x: point.x/2, y: point.y/2, width: 500, height: 400)
            let dataDic = resDic.valueForKey(Constants.LIST_VIEW_SEARCH_SALES_MAN) as! NSMutableDictionary
            let resultDic = NSMutableDictionary()
            let listView = ListViewPopover(frame: frame, parentFrame: parent, parentField: textfield, dataDic: dataDic, type: searchType, resultUpdater: resultDic)
            listView.backgroundColor = UIColor.blackColor()
            listView.alpha = 0.9
            parent.view.addSubview(listView)
        } else {
            //present a alret view.
        }
        
    }*/
    func txtFieldTouchInside() {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_SALES_MAN, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) as! NSMutableDictionary
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCompanyCodeListView" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            if countrySelected {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_COUNTRY
                countrySelected = false
            }else {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            }
            destVc?.parentViewName = Constants.VIEWER_ADD_EDIT_CUSTOMER_VIEWER
        } 
    }
    
    @IBAction func doTxtDateTouchDown(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuDateOfBirthBox
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtCuDateOfBirthBox
        popover!.sourceRect = txtCuDateOfBirthBox.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    func txtfieldGenderTouchInside() {
        let popoverContent = TrueFalseOptionController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuGenderBox
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 200, height: 50)
        popover!.sourceView = txtCuGenderBox
        popover!.sourceRect = txtCuGenderBox.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonDateTouchUpInside(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuDateOfBirthBox
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = buttonSelectDate
        popover!.sourceRect = buttonSelectDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonGenderTouchUpInside(_ sender: AnyObject) {
        let popoverContent = TrueFalseOptionController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuGenderBox
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 200, height: 50)
        popover!.sourceView = buttonSelectGender
        popover!.sourceRect = buttonSelectGender.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonCreatedByTouchUpInside(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_SALES_MAN, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) as! NSMutableDictionary
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            showErrorMsg("Error Message", message: "Error While fetching data. Please try again after some time.")
        }
    }
    
}
