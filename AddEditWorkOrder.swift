//
//  AddEditWorkOrder.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 10/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class AddEditWorkOrder: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var btnTestImage: UIButton!
    var ctlsSelectButtonDictionary : NSMutableDictionary = NSMutableDictionary()
    var ctlsDictionary : NSMutableDictionary = NSMutableDictionary()
    var ctlsObjsDictionary : NSMutableDictionary = NSMutableDictionary()
    @IBOutlet weak var lblLocationCreated: UILabel!
    
    @IBOutlet weak var lblWorkOrderNo: UILabel!
    
    @IBOutlet weak var lblWorkOrderNumberHead: UILabel!
    @IBOutlet weak var txtLocationAssigned: UITextField!
    @IBOutlet weak var PrescriptionType: UIButton!
    @IBOutlet weak var PrescriptionNumberLabel: UILabel!
    @IBOutlet weak var PrescriptiontypeTextField: UITextField!
    @IBOutlet weak var PrescriptionScrollView: UIScrollView!
    @IBOutlet weak var btnDeliveryDate: UIButton!
    @IBOutlet weak var txtWorkOrderDate: UITextField!
    @IBOutlet weak var btnWorkOrderDate: UIButton!
    @IBOutlet weak var txtDeliveryDate: UITextField!
    @IBOutlet weak var txtViewSpecialInstructions: UITextView!
    
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var txtPrescriptionNumberField: UITextField!
    @IBOutlet weak var txtSalesOrderNo: UITextField!
    @IBOutlet weak var txtCreatedBy: UITextField!
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    
    var selectShape = false
    var currentDropDownCtlSegue : String!
    var touchedCreatedBy = false
    var operationType : String!
    var woInfo : NSMutableDictionary!
    var soNo = ""
    var parentViewer : UIViewController!
    var onceOpend = true
    
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    let adminModel = AdminSettingModel.getInstance()
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) {
            txtLocationAssigned.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
        else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            txtCreatedBy.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SHOW_DROP_DOWN_OPTIONS){
            let dic = ctlsDictionary.value(forKey: currentDropDownCtlSegue) as! UITextField
            dic.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }else if onceOpend {
            
            fillData()
            onceOpend = false
        }
        /*if woInfo == nil {
            operationType = Constants.OPERATION_TYPE_ADD
        }*/
    }
    
    func fillData() {
        if let val = woInfo?.value(forKey: Constants.JWH_NO) {
            let tempVal = val
            lblWorkOrderNo.text = String(describing: tempVal)
        }
        if let val = woInfo?.value(forKey: Constants.JWH_LOCN_CODE) {
            lblLocationCreated.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.JWH_CR_DT) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtWorkOrderDate.text = dateFormatter.string(from: date!)
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_LOCN_ASSIGNED) {
            txtLocationAssigned.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.JWH_REF_NO) {
            let tempVal = val
            txtSalesOrderNo.text = String(describing: tempVal)
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_OPTIMETRIST) {
            txtCreatedBy.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_PRES_TYPE) {
            PrescriptiontypeTextField.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_PRES_NUMBER) {
            txtPrescriptionNumberField.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_DELIVERY_DATE) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtDeliveryDate.text = dateFormatter.string(from: date!)
        }
        if let val = woInfo?.value(forKey: Constants.JWH_REMARKS) {
            txtViewSpecialInstructions.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.JWD_REMARKS) {
            txtDetails.text = val as? String
        }
        PrescriptiontypeTextField.sendActions(for: .editingChanged)
        let ctlDic = ctlsDictionary 
        for (key,ctls) in ctlDic {
            if ctls is UISwitch {
                let tempSwitch = ctls as! UISwitch
                if let val = woInfo?.value(forKey: "TPOSWOD_FLEX_" + (key as! String)){
                    let tempVal = val
                    if tempVal as! String == "Yes" {
                        tempSwitch.isOn = true
                    }else{
                        tempSwitch.isOn = false
                    }
                    tempSwitch.sendActions(for: .valueChanged)
                }
                /*if tempSwitch.on {
                    woInfos.setValue("Yes", forKey: "TPOSWOD_FLEX_" + (key as! String))
                }else {
                    woInfos.setValue("No", forKey: "TPOSWOD_FLEX_" + (key as! String))
                }*/
            } else if ctls is UITextView {
                let tempTextview = ctls as! UITextView
                let val = woInfo?.value(forKey: "TPOSWOD_FLEX_" + (key as! String))
                if val != nil {
                    tempTextview.text = val as! String
                }
            } else if ctls is UITextField {
                let tempTextField = ctls as! UITextField
                let val = woInfo?.value(forKey: "TPOSWOD_FLEX_" + (key as! String))
                if val != nil {
                    tempTextField.text = val as! String
                }
            }
        }
    }
    
    @IBAction func performSaveButtonAction(_ sender: AnyObject) {
        
        let woModel = WorkOrderModel()
        if operationType == Constants.OPERATION_TYPE_VIEW {
            showErrorMsg("Cannot be modified!", message: "Only Viewing is permitted!")
            barButtonSave.isEnabled = false
            return
        }
        if operationType == Constants.OPERATION_TYPE_ADD && woInfo == nil {
            woInfo = NSMutableDictionary()
        }
        let adminDic = adminModel.userDataDic
        if operationType == Constants.OPERATION_TYPE_EDIT {
            if let val = woInfo.value(forKey: Constants.JWD_STATUS_CODE) {
                if val as! String == "001" {
                }else{
                    showErrorMsg("WorkOrder Cannot be updated", message: "Workshop has changed status for this Work Order")
                    return
                }
            }
            var wolocn = woInfo.value(forKey: Constants.JWH_LOCN_CODE) as! String
            let curlocn = adminDic.value(forKey: Constants.LOCN_CODE) as! String
            if curlocn != wolocn {
                showErrorMsg("WorkOrder Cannot be edited", message: "Work Order is created by another location!")
                return

            }
            /*if let val = woInfo.value(forKey: Constants.JWH_LOCN_CODE) {
                let val2 = adminDic.value(forKey: Constants.LOCN_CODE) as! String
                if val as! String != val2 {
                    showErrorMsg("WorkOrder Cannot be edited", message: "Work Order is created by another location!")
                    return
                }
            }*/
        }
        let countSetup = adminDic.value(forKey: Constants.COUNT_SETUP) as! NSDictionary
        
        if let val = txtWorkOrderDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select WorkOrder Date!")
                return
            }
        }
        if let val = txtSalesOrderNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter SalesOrder!")
                return
            }
            // add code to check salesorder is valid and patient is linked
        }
        if let val = txtLocationAssigned.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter Location this WorkOrder is Assigned!")
                return
            }
        }
        if let val = txtCreatedBy.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter CreatedBy!")
                return
            }
        }
        if let val = PrescriptiontypeTextField.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select Prescription Type!")
                return
            }
        }
        if let val = txtDeliveryDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select expected Delivery Date!")
                return
            }
        }
        if let val = txtPrescriptionNumberField.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select " + PrescriptionNumberLabel.text! + "!")
                return
            }
        }
        getValues(woInfo)
        
        let controller = WorkOrderController()
        if operationType == Constants.OPERATION_TYPE_ADD {
            woInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JWH_CR_UID)
            woInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JWD_CR_UID)
            woInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JWH_UPD_UID)
            woInfo.setValue(adminDic.value(forKey: Constants.COMP_CODE), forKey: Constants.JWH_COMP_CODE)
            woInfo.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.JWH_LOCN_CODE)
            woInfo.setValue("0", forKey: Constants.JWH_NO)
            woInfo.setValue("SO", forKey: Constants.JWH_REF_TXN_CODE)
            woInfo.setValue("N", forKey: Constants.JWH_COMPLETED_YN)
            let patientDict = getPatientDetailsFromSalesOrder()
            let patientNo = patientDict.value(forKey: Constants.PM_SYS_ID) as! Int
            woInfo.setValue(patientNo, forKey: Constants.JWH_PM_SYS_ID)
            woInfo.setValue(patientDict.value(forKey: Constants.TRANS_PATIENT_NO), forKey: Constants.JWH_PATIENT_ID)
        }
        
        woModel.requestType.setValue(woInfo, forKey: Constants.SAVE_WORK_ORDER)
        woModel.requestType.setValue(operationType, forKey: Constants.OPERATION_TYPE)
        
        let resWoModel = controller.performSaveOperation(woModel) as! WorkOrderModel
        
        var msgTitle :String!
        if operationType == Constants.OPERATION_TYPE_ADD {
            msgTitle = "created"
            
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            msgTitle = "edited"
        } else {
            msgTitle = "Delete Operation"
        }
        if resWoModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
            self.woInfo = resWoModel.responseResult.value(forKey: Constants.SAVE_WORK_ORDER_INFO) as? NSMutableDictionary
            /*if customerInfo != nil  && operationType == Constants.OPERATION_TYPE_ADD {
                if let cuId = customerInfo?.valueForKey(Constants.PM_CUST_NO) as? String {
                    let cuHomeScreen = parentViewer as? CustomerHomeScreenViewer
                    cuHomeScreen?.searchResult.removeAllObjects()
                    cuHomeScreen?.searchResult.setValue(customerInfo, forKey: cuId)
                    cuHomeScreen?.searchkeyResult = cuHomeScreen?.searchResult.allKeys  as! [String]
                }
            } else if customerInfo != nil && operationType == Constants.OPERATION_TYPE_EDIT {
                if let cuId = customerInfo?.valueForKey(Constants.PM_CUST_NO) as? String {
                    let cuHomeScreen = parentViewer as? CustomerDetailedInfoViewer
                    cuHomeScreen?.updateEditedDataObject(customerInfo)
                }
            }*/
            var msg = "WorkOrder Saved Successfully"
            //showErrorMsg(msgTitle, message: msg)
            showYesNoValidatorToSummarize("Successfully " + msgTitle  + "!", message: "You can view the summary by clicking 'Show Summary'")
        } else {
            showErrorMsg(msgTitle, message: "Error while Saving WorkOrder.")
        }
    }
    
    func getValues(_ woInfos : NSMutableDictionary) {
        if let val = txtWorkOrderDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            woInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.JWH_DT)
            //}
        }
        if let val = lblLocationCreated.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.JWH_LOCN_CODE)
        }
        if let val = txtLocationAssigned.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.TPOSWOD_LOCN_ASSIGNED)
        }
        if let val = txtSalesOrderNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.JWH_REF_NO)
            //need to update so ref sys id in API itself - imp
            woInfos.setValue(val, forKey: Constants.JWH_REF_SYS_ID)
        }
        if let val = txtCreatedBy.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.TPOSWOD_OPTIMETRIST)
        }
        if let val = PrescriptiontypeTextField.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.TPOSWOD_PRES_TYPE)
        }
        if let val = txtPrescriptionNumberField.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.TPOSWOD_PRES_NUMBER)
        }
        if let val = txtDeliveryDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            woInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.TPOSWOD_DELIVERY_DATE)
        }
        if let val = txtViewSpecialInstructions.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.JWH_REMARKS)
        }
        if let val = txtDetails.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.JWD_REMARKS)
        }
        let ctlDic = ctlsDictionary 
        for (key,ctls) in ctlDic {
            if ctls is UISwitch {
                let tempSwitch = ctls as! UISwitch
                if tempSwitch.isOn {
                    woInfos.setValue("Yes", forKey: "TPOSWOD_FLEX_" + (key as! String))
                }else {
                    woInfos.setValue("No", forKey: "TPOSWOD_FLEX_" + (key as! String))
                }
            } else if ctls is UITextView {
                let tempTextview = ctls as! UITextView
                if let val = tempTextview.text {
                    woInfos.setValue(val, forKey: "TPOSWOD_FLEX_" + (key as! String))
                }
            } else if ctls is UITextField {
                let tempTextField = ctls as! UITextField
                if let val = tempTextField.text {
                    woInfos.setValue(val, forKey: "TPOSWOD_FLEX_" + (key as! String))
                }
            }
        }
        
    }
    
    @IBAction func btnPrescriptionNumberInfoTouchUpInside(_ sender: AnyObject) {
        
        let presType = PrescriptiontypeTextField.text
        let sonoval = txtSalesOrderNo.text
        let presNum = txtPrescriptionNumberField.text
        let set = CharacterSet(charactersIn: " .?")
        let result = presType!.trimmingCharacters(in: set)
        let soresult = sonoval!.trimmingCharacters(in: set)
        let presNumresult = presNum!.trimmingCharacters(in: set)
        if result == "" {
            showErrorMsg("Error", message: "Please select Prescription type")
        } else if soresult == "" {
            showErrorMsg("Error", message: "Please enter SalesOrder No.")
        } else if presNumresult == "" {
            showErrorMsg("Error", message: "Please enter Prescription No.")
        }else if result == "ContactLenses" {
            let patientNo = validateSalesOrderPatient()
            if patientNo != 0 {
                let requestModel : RxContactLenseModel =  RxContactLenseModel()
                let controller : RxContactLenseController = RxContactLenseController()
                requestModel.reqeustType.setValue(patientNo, forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
                let responseModel = controller.performSyncRequest(requestModel) as? RxContactLenseModel
                searcResultDic = NSMutableDictionary()
                searcResultDic = responseModel!.responseResult.value(forKey: txtPrescriptionNumberField.text!) as! NSMutableDictionary
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerRxContactLensDetailView", sender: self)
                } else {
                //present a alret view.
                }
            } else {
                showErrorMsg("Error", message: "Invalid SalesOrder No.")
            }
        } else if result == "RXLenses" || result == "StockLenses" {
            let patientDict = getPatientDetailsFromSalesOrder()
            let patientNo = patientDict.value(forKey: Constants.PM_SYS_ID) as! Int
            if patientNo != 0 {
                let requestModel : RxGlassesModel =  RxGlassesModel()
                let controller : RxGlassesController = RxGlassesController()
                let custNo = patientDict.value(forKey: Constants.TRANS_PATIENT_NO)
                let reqDic : NSMutableDictionary = NSMutableDictionary()
                reqDic.setValue(patientNo, forKey: Constants.PM_SYS_ID)
                reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
                requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_RX_GLASSES)
                let responseModel = controller.performSyncRequest(requestModel) as? RxGlassesModel
                searcResultDic = responseModel!.responseResult.value(forKey: txtPrescriptionNumberField.text!) as! NSMutableDictionary
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                    performSegue(withIdentifier: "ToCustomerRxGlassesDetailView", sender: self)
                } else {
                    //present a alret view.
                }
            }else {
                showErrorMsg("Error", message: "Invalid SalesOrder No.")
            }
        } else if result == "SlitKReadings" {
            let requestModel : SlitKReadingModel =  SlitKReadingModel()
            let controller : SlitKReadingController = SlitKReadingController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_SLIT_K_READING)
            let responseModel = controller.performSyncRequest(requestModel) as? SlitKReadingModel
            searcResultDic = responseModel!.responseResult.value(forKey: txtPrescriptionNumberField.text!) as! NSMutableDictionary
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerSlitKReadingsDetailView", sender: self)
            } else {
                //present a alret view.
            }
        } else if result == "TrialDetails" {
            let requestModel : TrailModel =  TrailModel()
            let controller : TrailController = TrailController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_TRAIL)
            let responseModel = controller.performSyncRequest(requestModel) as? TrailModel
            searcResultDic = responseModel!.responseResult.value(forKey: txtPrescriptionNumberField.text!) as! NSMutableDictionary
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerTrailDetailsDetailView", sender: self)
            } else {
                //present a alret view.
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocationAssigned.delegate = self
        txtCreatedBy.delegate = self
        //need to remove this - check
        //operationType = Constants.OPERATION_TYPE_ADD
        if operationType == Constants.OPERATION_TYPE_ADD {
            lblLocationCreated.text = adminModel.userDataDic.value(forKey: Constants.LOCN_CODE) as? String
        }
        if soNo != "" {
            txtSalesOrderNo.text = soNo
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        txtWorkOrderDate.text = result
        txtDeliveryDate.text = result
    }
    
    
    @IBAction func btnCreatedByTouchUpInside(_ sender: AnyObject) {
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
            touchedCreatedBy = true
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnSalesOrderTouchInside(_ sender: AnyObject) {
        let soNumber = txtSalesOrderNo.text
        let set = CharacterSet(charactersIn: " .?")
        let trimString = soNumber!.trimmingCharacters(in: set)
        if trimString == "" {
            showErrorMsg("Value Required", message: "Please enter the Sales Order NO.!")
        }else{
            let workordermodel = WorkOrderModel()
            let controller = WorkOrderController()
            let searchReq = NSMutableDictionary()
            PrescriptionScrollView.showsVerticalScrollIndicator = true
            searchReq.setValue(txtSalesOrderNo.text,  forKey: Constants.TRANS_NO)
            workordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
            let resModel = controller.performSyncRequest(workordermodel) as! WorkOrderModel
            let resDic = resModel.responseResult
            if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) as! NSMutableDictionary
                performSegue(withIdentifier: "TOSalesOrderView", sender: self)
            } else {
                showErrorMsg("Error Occurred", message: "Unabled to find the Sales Order details!")
            }
        }
    }
    
    
    @IBAction func txtCreatedByTouchDown(_ sender: AnyObject) {
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
            touchedCreatedBy = true
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ToCompanyCodeListViewForSalesMan" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            if touchedCreatedBy {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            }else {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_LOCATION_CODE
            }
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
        }
       else if segue.identifier == "TOSalesOrderView" {
            let destVc = segue.destination as? CustomerHistorySalesOrderView
            destVc?.invoiceData = searcResultDic
            let val = searcResultDic.value(forKey: Constants.TRANS_ITEMS)
        //Need to handle this later
            if val is NSArray {
                destVc?.invoiceTableKey = searcResultDic.value(forKey: Constants.TRANS_ITEMS) as! [NSDictionary]
            }
            destVc?.parentViewName = "AddEditWorkOrder"
        }
       else if segue.identifier == "ToCustomerRXContactLens" {
            let destVc = segue.destination as? CustomerRxContactLenseView
            destVc?.rxContactLenseData = searcResultDic
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
            let customerInfo : NSMutableDictionary = NSMutableDictionary()
            let customerInfoTemp = getPatientDetailsFromSalesOrder() 
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_PATIENT_NAME), forKey: Constants.PM_PATIENT_NAME)
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_PATIENT_NO), forKey: Constants.PM_CUST_NO)
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_SALESMAN), forKey: Constants.PM_SM_CODE)
            destVc?.customerInfo = customerInfo
            destVc?.parentView = self
        
        }
       else if segue.identifier == "ToCustomerRxGlasses" {
            let destVc = segue.destination as? CustomerRxGlassesView
            destVc?.rxGlassData = searcResultDic
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
            let customerInfo : NSMutableDictionary = NSMutableDictionary()
            let customerInfoTemp = getPatientDetailsFromSalesOrder() 
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_PATIENT_NAME), forKey: Constants.PM_PATIENT_NAME)
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_PATIENT_NO), forKey: Constants.PM_CUST_NO)
            customerInfo.setValue(customerInfoTemp.value(forKey: Constants.TRANS_SALESMAN), forKey: Constants.PM_SM_CODE)
            destVc?.customerInfo = customerInfo
            destVc?.parentView = self
       }else if segue.identifier == "ToDropDownValues" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            if selectShape {
                destVc?.imageDisplay = true
                selectShape = false
            }
            destVc?.searchType = Constants.LIST_VIEW_SHOW_DROP_DOWN_OPTIONS
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
       }
       else if segue.identifier == "ToCustomerSlitKReadings" {
        let destVc = segue.destination as? CustomerSlitAndKReadingsView
        destVc?.slitKReadingData = searcResultDic
        destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
        destVc?.parentView = self
        }
       else if segue.identifier == "ToCustomerTrail" {
        let destVc = segue.destination as? CustomerTrailViewer
        destVc?.trailData = searcResultDic
        destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER
        destVc?.parentView = self
        }
       else if segue.identifier == "ToCustomerRxContactLensDetailView" {
            let destVc = segue.destination as? RxContactLenseDetailView
            destVc?.rxContactLenseInfo = searcResultDic
            
        }
       else if segue.identifier == "ToCustomerRxGlassesDetailView" {
            let destVc = segue.destination as? RXGlassesDetailedView
            destVc?.rxGlassData = searcResultDic
        }
       else if segue.identifier == "ToCustomerSlitKReadingsDetailView" {
            let destVc = segue.destination as? SlitAndKReadingDetailedView
            destVc?.slitKReadingData = searcResultDic
        }
       else if segue.identifier == "ToCustomerTrailDetailsDetailView" {
            let destVc = segue.destination as? TrailDetailedView
            destVc?.trailData = searcResultDic
       } else if segue.identifier == "ToWorkOrderSummary" {
            let destVc = segue.destination as? WorkOrderSummary
            if let result_number = woInfo.value(forKey: Constants.JWH_NO) as? NSNumber
            {
                destVc?.woId = "\(result_number)"
            }
        }
        searchResultUpdater = NSMutableDictionary()
    }
    
    
    
    @IBAction func txtLocationAssignedTouchDown(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_LOCATION_CODE, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) as! NSMutableDictionary
            touchedCreatedBy = false
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }

    }
    
    
    @IBAction func txtLocationAssignedTouchUpInside(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_LOCATION_CODE, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) as! NSMutableDictionary
            touchedCreatedBy = false
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func PrescriptionTypeEditingChanged(_ sender: AnyObject) {
        do {
        ctlsDictionary = NSMutableDictionary()
        ctlsSelectButtonDictionary = NSMutableDictionary()
        let subViews = self.PrescriptionScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let workordermodel = WorkOrderModel()
        let controller = WorkOrderController()
        let searchReq = NSMutableDictionary()
        PrescriptionScrollView.showsVerticalScrollIndicator = true
        searchReq.setValue(PrescriptiontypeTextField.text,  forKey: Constants.DYN_VISIT_TYPE)
        workordermodel.requestType.setValue(searchReq, forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE)
        let resModel = controller.performSyncRequest(workordermodel) as! WorkOrderModel
        let dynCtrlObj = resModel.responseResult.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) as! NSMutableDictionary
        let dynControlItems = dynCtrlObj.value(forKey: Constants.DYN_CTLS) as! NSMutableDictionary
        let dynControlsCount = dynCtrlObj.value(forKey: Constants.DYN_CTLS_NUMBER) as! NSInteger
        
        if (dynControlsCount>0) {
            ctlsObjsDictionary = dynControlItems
            let lblPresHeader = UILabel(frame: CGRect(x: 2, y: 1, width: 1020, height: 40))
            lblPresHeader.text = PrescriptiontypeTextField.text! + " Details"
            lblPresHeader.backgroundColor = UIColor(red: 0.3, green: 160.0/255.0, blue: 0.5, alpha: 1.0)
            lblPresHeader.textColor = UIColor.white
            lblPresHeader.font = UIFont(name: "Hoefler Text", size: 18)
            lblPresHeader.textAlignment = NSTextAlignment.center
            PrescriptionScrollView.addSubview(lblPresHeader)
            var x = 15
            var y = 41
            var GroupName = ""
            var lastSwitch = false
            var lastTextType = false
            //for var index = 1; index <= dynControlsCount; index += 1 {
            for index in stride(from: 1, to: dynControlsCount+1, by: 1){
                let controlDef = dynControlItems.value(forKey: String(index)) as! NSMutableDictionary
                var controlType = controlDef.value(forKey: Constants.CTL_TYPE)
                var mappedField = controlDef.value(forKey: Constants.CTL_MAPPED_FIELD)
                if controlType as! String  == Constants.CTL_SWITCH_TYPE {
                    if x > 920 {
                        x = 15
                        y = y + 40
                    }
                    if (controlDef.value(forKey: Constants.CTL_GROUP) as AnyObject).lowercased == "yes" && (GroupName == "" ||  GroupName != controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String ){
                        GroupName = controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String
                        let labelCtlHeader = UILabel(frame: CGRect(x: 2, y: CGFloat(y), width: 1020, height: 30))
                        labelCtlHeader.text = " " + GroupName
                        labelCtlHeader.backgroundColor = UIColor(red: 0.5, green: 190.0/255.0, blue: 0.5, alpha: 1.0)
                        labelCtlHeader.textColor = UIColor.white
                        labelCtlHeader.font = UIFont(name: "Hoefler Text", size: 17)
                        PrescriptionScrollView.addSubview(labelCtlHeader)
                        y = y + 40
                    }
                    let switchCtl = UISwitch(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 50, height: 30))
                    switchCtl.addTarget(self, action: #selector(AddEditWorkOrder.swithValueChanged(_:)), for: UIControlEvents.valueChanged)
                    switchCtl.tag = index
                    PrescriptionScrollView.addSubview(switchCtl)
                    let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                    let labelCtl = UILabel(frame: CGRect(x: CGFloat(x + 60), y: CGFloat(y), width: 220, height: 30))
                    labelCtl.text = labelName
                    labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                    labelCtl.textColor = lblWorkOrderNumberHead.textColor
                    PrescriptionScrollView.addSubview(labelCtl)
                    ctlsDictionary[mappedField] = switchCtl
                    x = x + 250
                    lastSwitch = true
                    lastTextType = false
                } else if controlType as! String == Constants.CTL_TEXTAREA_TYPE {
                    if (controlDef.value(forKey: Constants.CTL_GROUP) as AnyObject).lowercased == "yes" && (GroupName == "" ||  GroupName != controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String ){
                        GroupName = controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String
                        let labelCtlHeader = UILabel(frame: CGRect(x: 2, y: CGFloat(y), width: 1020, height: 30))
                        labelCtlHeader.text = " " + GroupName
                        labelCtlHeader.backgroundColor = UIColor(red: 0.5, green: 190.0/255.0, blue: 0.5, alpha: 1.0)
                        labelCtlHeader.textColor = UIColor.white
                        labelCtlHeader.font = UIFont(name: "Hoefler Text", size: 17)
                        PrescriptionScrollView.addSubview(labelCtlHeader)
                    }
                    y = y + 45
                    x = 15
                    let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                    let labelCtl = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 150, height: 30))
                    labelCtl.text = labelName
                    labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                    labelCtl.textColor = lblWorkOrderNumberHead.textColor
                    PrescriptionScrollView.addSubview(labelCtl)
                    let textAreaCtl = UITextView(frame: CGRect(x: CGFloat(x + 181), y: CGFloat(y), width: 720, height: 60))
                    textAreaCtl.isScrollEnabled = true
                    textAreaCtl.font = UIFont(name: "Hoefler Text", size: 17)
                    PrescriptionScrollView.addSubview(textAreaCtl)
                    ctlsDictionary[mappedField] = textAreaCtl
                    lastSwitch = false
                    lastTextType = false
                    y = y + 100
                    x = 15
                } else if controlType as! String == Constants.CTL_TEXTFIELD_TYPE || controlType as! String == Constants.CTL_DROPDOWN {
                    if (controlDef.value(forKey: Constants.CTL_GROUP) as AnyObject).lowercased == "yes" && (GroupName == "" ||  GroupName != controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String ){
                        GroupName = controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String
                        let labelCtlHeader = UILabel(frame: CGRect(x: 2, y: CGFloat(y), width: 1020, height: 30))
                        labelCtlHeader.text = " " + GroupName
                        labelCtlHeader.backgroundColor = UIColor(red: 0.5, green: 190.0/255.0, blue: 0.5, alpha: 1.0)
                        labelCtlHeader.textColor = UIColor.white
                        labelCtlHeader.font = UIFont(name: "Hoefler Text", size: 17)
                        PrescriptionScrollView.addSubview(labelCtlHeader)
                        y = y + 45
                        lastTextType = false
                    }
                    if GroupName == controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String && lastSwitch {
                       y = y + 45
                    }
                    if lastTextType &&  controlType as! String != Constants.CTL_DROPDOWN{
                        x = 528
                        y = y - 45
                        lastTextType = false
                    }else {
                        x = 15
                        lastTextType = true
                    }
                    let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                    let labelCtl = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 150, height: 30))
                    labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                    labelCtl.text = labelName
                    labelCtl.textColor = lblWorkOrderNumberHead.textColor
                    PrescriptionScrollView.addSubview(labelCtl)
                    let textFieldCtl = UITextField(frame: CGRect(x: CGFloat(x + 181), y: CGFloat(y), width: 250, height: 30))
                    textFieldCtl.layer.cornerRadius = 3
                    textFieldCtl.font = UIFont(name: "Hoefler Text", size: 17)
                    //textFieldCtl.addTarget(self, action: "txtFieldEditingDidEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
                    textFieldCtl.tag = index
                    //textFieldCtl.borderStyle = UITextBorderStyle.Line
                    textFieldCtl.backgroundColor = UIColor.white
                    PrescriptionScrollView.addSubview(textFieldCtl)
                    if controlType as! String == Constants.CTL_DROPDOWN {
                        let btn = UIButton(type: UIButtonType.custom) as UIButton
                        btn.frame = CGRect(x: CGFloat(x + 408), y: CGFloat(y + 3), width: 20, height: 25)
                        btn.setImage(UIImage(named: "DropDown.png"), for: UIControlState())
                        btn.addTarget(self, action: #selector(AddEditWorkOrder.btnDropDownTouchedUpInside(_:)), for: UIControlEvents.touchUpInside)
                        btn.tag = index
                        PrescriptionScrollView.addSubview(btn)
                        ctlsSelectButtonDictionary[mappedField] = btn
                    }
                    lastSwitch = false
                    ctlsDictionary[mappedField] = textFieldCtl
                    y = y + 45
                    x = 15
                }
                
                //to handle all the group controller switch
                let ctlDic = ctlsDictionary
                for (key,ctls) in ctlDic {
                    if ctls is UISwitch {
                        let tempSwitch = ctls as! UISwitch
                        tempSwitch.sendActions(for: .valueChanged)
                    }
                }
                //Ends - to handle all the group controller switch
            }
            PrescriptionScrollView.contentSize = CGSize(width: 1024, height: CGFloat(y + 50))
        }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func swithValueChanged(_ sender:UISwitch){
        let a = sender.tag
        
        let ctlsObj = ctlsObjsDictionary.value(forKey: String(a)) as! NSMutableDictionary
        if ctlsObj.value(forKey: Constants.CTL_GROUP_FIELDS) as! String == "Yes" {
            if sender.isOn {
                enableCtlGroup(groupName: ctlsObj.value(forKey: Constants.CTL_GROUP_NAME) as! String)
            }else {
                disableCtlGroup(groupName: ctlsObj.value(forKey: Constants.CTL_GROUP_NAME) as! String)
            }
        }
    }
    
    func disableCtlGroup(groupName: String){
        var myArray = [String]();
        for (key,ctls) in ctlsObjsDictionary {
            let tempCtls = ctls as! NSMutableDictionary
            var tempGroupName = tempCtls.value(forKey: Constants.CTL_GROUP_NAME) as! String
            var tempGroupFieldController = tempCtls.value(forKey: Constants.CTL_GROUP_FIELDS) as! String
            var keyval =  key as! String
            if tempGroupFieldController == "No" && tempGroupName == groupName {
                var tempMappedField = tempCtls.value(forKey: Constants.CTL_MAPPED_FIELD) as! String
                myArray.append(tempMappedField)
            }
        }
        
        let ctlDic = ctlsDictionary
        for (key,ctls) in ctlDic {
            var keyval =  key as! String
            if myArray.contains(keyval){
                if ctls is UISwitch {
                    let tempSwitch = ctls as! UISwitch
                    tempSwitch.isUserInteractionEnabled = false
                    tempSwitch.isOn = false
                } else if ctls is UITextView {
                    let tempTextview = ctls as! UITextView
                    tempTextview.isUserInteractionEnabled = false
                    tempTextview.backgroundColor = UIColor(red: 236.0/255.0, green: 233.0/255.0, blue: 216.0/255.0, alpha: 1.0)
                    tempTextview.text = ""
                } else if ctls is UITextField {
                    let tempTextField = ctls as! UITextField
                    tempTextField.isUserInteractionEnabled = false
                    tempTextField.backgroundColor = UIColor(red: 236.0/255.0, green: 233.0/255.0, blue: 216.0/255.0, alpha: 1.0)
                    tempTextField.text = ""
                    var tempCtl = ctlsSelectButtonDictionary.value(forKey: keyval)
                    if tempCtl != nil {
                        let tempBtn = tempCtl as! UIButton
                        tempBtn.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    func enableCtlGroup(groupName: String){
        var myArray = [String]();
        for (key,ctls) in ctlsObjsDictionary {
            let tempCtls = ctls as! NSMutableDictionary
            var tempGroupName = tempCtls.value(forKey: Constants.CTL_GROUP_NAME) as! String
            var tempGroupFieldController = tempCtls.value(forKey: Constants.CTL_GROUP_FIELDS) as! String
            var keyval =  key as! String
            if tempGroupFieldController == "No" && tempGroupName == groupName {
                var tempMappedField = tempCtls.value(forKey: Constants.CTL_MAPPED_FIELD) as! String
                myArray.append(tempMappedField)
            }
        }
        
        let ctlDic = ctlsDictionary
        for (key,ctls) in ctlDic {
            var keyval =  key as! String
            if myArray.contains(keyval){
                if ctls is UISwitch {
                    let tempSwitch = ctls as! UISwitch
                    tempSwitch.isUserInteractionEnabled = true
                } else if ctls is UITextView {
                    let tempTextview = ctls as! UITextView
                    tempTextview.isUserInteractionEnabled = true
                    tempTextview.backgroundColor = txtCreatedBy.backgroundColor
                } else if ctls is UITextField {
                    let tempTextField = ctls as! UITextField
                    tempTextField.isUserInteractionEnabled = true
                    tempTextField.backgroundColor = txtCreatedBy.backgroundColor
                    var tempCtl = ctlsSelectButtonDictionary.value(forKey: keyval)
                    if tempCtl != nil {
                        let tempBtn = tempCtl as! UIButton
                        tempBtn.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    func txtFieldEditingDidEnd(_ sender:UITextField){
        /*let a = sender.tag
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtWorkOrderDate
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(400, 400)
        popover!.sourceView = txtWorkOrderDate
        popover!.sourceRect = txtWorkOrderDate.bounds
        popover?.permittedArrowDirections = .Up
        self.presentViewController(nav, animated: true, completion: nil)
        let myString = sender.text
        let sliced = String(myString!.characters.dropLast())
        sender.text = sliced
        txtPrescriptionNumberField.text = ""  */
    }
    
    func btnDropDownTouchedUpInside(_ sender:UIButton!) {
        let a = sender.tag
        
        let tempCtlDic = ctlsObjsDictionary.value(forKey: String(a)) as! NSMutableDictionary
        if tempCtlDic == nil {
            showErrorMsg("Info...", message: "No Options found!")
        }else {
            var tempValues = tempCtlDic.value(forKey: Constants.CTL_VALUES) as! NSMutableDictionary
            var tempSelectImage = tempCtlDic.value(forKey: Constants.CTL_IMAGE_SELECT) as! String
            if tempSelectImage == "Yes" {
                selectShape = true
            }else {
                selectShape = false
            }
            searcResultDic = tempValues
            currentDropDownCtlSegue = tempCtlDic.value(forKey: Constants.CTL_MAPPED_FIELD) as! String
            performSegue(withIdentifier: "ToDropDownValues", sender: self)
        }
    }
    
    @IBAction func btnWorkOrderDate(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtWorkOrderDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtWorkOrderDate
        popover!.sourceRect = txtWorkOrderDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let btn = UIButton(type: UIButtonType.custom) as UIButton
                btn.frame = CGRect(x: CGFloat(40), y: CGFloat(40), width: 350, height: 75)
                btn.setImage(UIImage(data: data), for: UIControlState())
                self.PrescriptionScrollView.addSubview(btn)
                //self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func btnDeliveryDateTouchUpInside(_ sender: AnyObject) {
        /*if let checkedUrl = URL(string: "http://citrix.aljaber.ae/evisionsoftpostest/UploadedFiles/Pilot.png") {
            //imageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }*/
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtDeliveryDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtDeliveryDate
        popover!.sourceRect = txtDeliveryDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func txtPrescriptionNumberTouchDown(_ sender: AnyObject) {
        let presType = PrescriptiontypeTextField.text
        let soNumb = txtSalesOrderNo.text
        let set = CharacterSet(charactersIn: " .?")
        let presTypeVal = presType!.trimmingCharacters(in: set)
        let soNumbVal = soNumb!.trimmingCharacters(in: set)
        if presTypeVal == "" {
            showErrorMsg("Value Required", message: "Please select Prescription type")
        }else if soNumbVal == "" {
            showErrorMsg("Value Required", message: "Please enter Sales Order NO.")
        }else if presTypeVal == "ContactLenses" {
            let patientNo = validateSalesOrderPatient()
            if patientNo != 0 {
                let requestModel : RxContactLenseModel =  RxContactLenseModel()
                let controller : RxContactLenseController = RxContactLenseController()
                requestModel.reqeustType.setValue(patientNo, forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
                let responseModel = controller.performSyncRequest(requestModel) as? RxContactLenseModel
                searcResultDic = responseModel!.responseResult
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                    performSegue(withIdentifier: "ToCustomerRXContactLens", sender: self)
                } else {
                    //present a alret view.
                }
            }
        } else if presTypeVal == "StockLenses" || presTypeVal == "RXLenses" {
            let patientDict = getPatientDetailsFromSalesOrder()
            let patientNo = patientDict.value(forKey: Constants.PM_SYS_ID) as! Int
            if patientNo != 0 {
                let requestModel : RxGlassesModel =  RxGlassesModel()
                let controller : RxGlassesController = RxGlassesController()
                let custNo = patientDict.value(forKey: Constants.TRANS_PATIENT_NO)
                let reqDic : NSMutableDictionary = NSMutableDictionary()
                reqDic.setValue(patientNo, forKey: Constants.PM_SYS_ID)
                reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
                requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_RX_GLASSES)
                let responseModel = controller.performSyncRequest(requestModel) as? RxGlassesModel
                searcResultDic = responseModel!.responseResult
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                    performSegue(withIdentifier: "ToCustomerRxGlasses", sender: self)
                } else {
                    //present a alret view.
                }
            }
        } else if presTypeVal == "SlitKReadings" {
            let requestModel : SlitKReadingModel =  SlitKReadingModel()
            let controller : SlitKReadingController = SlitKReadingController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_SLIT_K_READING)
            let responseModel = controller.performSyncRequest(requestModel) as? SlitKReadingModel
            searcResultDic = responseModel!.responseResult
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerSlitKReadings", sender: self)
            } else {
                //present a alret view.
            }
        } else if presTypeVal == "TrialDetails" {
            let requestModel : TrailModel =  TrailModel()
            let controller : TrailController = TrailController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_TRAIL)
            let responseModel = controller.performSyncRequest(requestModel) as? TrailModel
            searcResultDic = responseModel!.responseResult
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerTrail", sender: self)
            } else {
                //present a alret view.
            }
        }
    }
    
    @IBAction func txtDeliveryDateTouchDown(_ sender: Any) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtDeliveryDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtDeliveryDate
        popover!.sourceRect = txtDeliveryDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    /*for (key,ctls) in ctlsDictionary {
    if ctls is UISwitch {
    let tempSwitch = ctls as! UISwitch
    if tempSwitch.on {
    
    }
    } else if ctls is UITextView {
    let tempTextview = ctls as! UITextView
    
    } else if ctls is UITextField {
    let tempTextField = ctls as! UITextField
    
    }
    }*/

    func showSummary(){
        performSegue(withIdentifier: "ToWorkOrderSummary", sender: self)
    }
    
    func showYesNoValidatorToSummarize(_ title: String, message: String){
        var refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        var height:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.25)
        refreshAlert.view.addConstraint(height);
        var width:NSLayoutConstraint = NSLayoutConstraint(item: refreshAlert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 0.80)
        refreshAlert.view.addConstraint(width);
        
        refreshAlert.addAction(UIAlertAction(title: "No Thank's", style: .default, handler: { (action: UIAlertAction!) in
            self.operationType = Constants.OPERATION_TYPE_EDIT
            if let val = self.woInfo?.value(forKey: Constants.JWH_NO) {
                let tempVal = val
                self.lblWorkOrderNo.text = String(describing: tempVal)
            }
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Show Summary", style: .default, handler: { (action: UIAlertAction!) in
            self.operationType = Constants.OPERATION_TYPE_EDIT
            if let val = self.woInfo?.value(forKey: Constants.JWH_NO) {
                let tempVal = val
                self.lblWorkOrderNo.text = String(describing: tempVal)
            }
            self.showSummary()
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getPatientDetailsFromSalesOrder() -> NSMutableDictionary {
        let set = CharacterSet(charactersIn: " .?")
        let patientDic = NSMutableDictionary()
        patientDic.setValue(0, forKey: Constants.PM_SYS_ID)
        let workordermodel = WorkOrderModel()
        let controller = WorkOrderController()
        let searchReq = NSMutableDictionary()
        PrescriptionScrollView.showsVerticalScrollIndicator = true
        searchReq.setValue(txtSalesOrderNo.text,  forKey: Constants.TRANS_NO)
        workordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
        let resModel = controller.performSyncRequest(workordermodel) as! WorkOrderModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) as! NSMutableDictionary
            let tempPatientNo = searcResultDic.value(forKey: Constants.TRANS_PATIENT_NO)
            if (tempPatientNo! as AnyObject).trimmingCharacters(in: set) != "" {
                let tempPatientName = searcResultDic.value(forKey: Constants.TRANS_PATIENT_NAME)
                let tempSalesmanName = searcResultDic.value(forKey: Constants.TRANS_SALESMAN)
                patientDic.setValue(tempPatientName, forKey: Constants.TRANS_PATIENT_NAME)
                patientDic.setValue(tempPatientNo, forKey: Constants.TRANS_PATIENT_NO)
                patientDic.setValue(tempSalesmanName, forKey: Constants.TRANS_SALESMAN)
                var patientNoArr = (tempPatientNo as AnyObject).components(separatedBy: "-")
                if patientNoArr.count > 1 {
                    var temp = patientNoArr[1]
                    patientDic.setValue( Int(temp)!, forKey: Constants.PM_SYS_ID)
                }
            }
        }else {
            showErrorMsg("Error Occurred", message: "Unabled to find the Sales Order details!")
        }
        return patientDic
    }
    
    func validateSalesOrderPatient() -> Int{
        var patientNo = 0
        let set = CharacterSet(charactersIn: " .?")
        let workordermodel = WorkOrderModel()
        let controller = WorkOrderController()
        let searchReq = NSMutableDictionary()
        PrescriptionScrollView.showsVerticalScrollIndicator = true
        searchReq.setValue(txtSalesOrderNo.text,  forKey: Constants.TRANS_NO)
        workordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
        let resModel = controller.performSyncRequest(workordermodel) as! WorkOrderModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) as! NSMutableDictionary
            var status = searcResultDic.value(forKey: "Status") as! String
            if status == "success" {
                var tempPatientNo = searcResultDic.value(forKey: Constants.TRANS_PATIENT_NO)
                if (tempPatientNo! as AnyObject).trimmingCharacters(in: set) != "" {
                    var patientNoArr = (tempPatientNo as AnyObject).components(separatedBy: "-")
                    if patientNoArr.count > 1 {
                        var temp = patientNoArr[1]
                        patientNo = Int(temp)!
                    }
                    if patientNo == 0 {
                        showErrorMsg("Sorry..", message: "Seems like Customer not linked to SalesOrder!")
                    }
                }
            }else{
                showErrorMsg("Error Occurred", message: "Please enter a valid SalesOrder Number!")
                showErrorMsg("Info...", message: "Kindly check customer is linked to the SalesOrder")
            }
        } else {
            showErrorMsg("Error Occurred", message: "Unabled to find the Sales Order details!")
        }
        return patientNo
    }
    
    @IBAction func PrescriptionNumberSelect(_ sender: AnyObject) {
        
        let presType = PrescriptiontypeTextField.text
        let soNumb = txtSalesOrderNo.text
        let set = CharacterSet(charactersIn: " .?")
        let presTypeVal = presType!.trimmingCharacters(in: set)
        let soNumbVal = soNumb!.trimmingCharacters(in: set)
        if presTypeVal == "" {
            showErrorMsg("Value Required", message: "Please select Prescription type")
        }else if soNumbVal == "" {
            showErrorMsg("Value Required", message: "Please enter Sales Order NO.")
        }else if presTypeVal == "ContactLenses" {
            let patientNo = validateSalesOrderPatient()
            if patientNo != 0 {
                let requestModel : RxContactLenseModel =  RxContactLenseModel()
                let controller : RxContactLenseController = RxContactLenseController()
                requestModel.reqeustType.setValue(patientNo, forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
                let responseModel = controller.performSyncRequest(requestModel) as? RxContactLenseModel
                searcResultDic = responseModel!.responseResult
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                    performSegue(withIdentifier: "ToCustomerRXContactLens", sender: self)
                } else {
                    //present a alret view.
                }
            }
        } else if presTypeVal == "StockLenses" || presTypeVal == "RXLenses" {
            let patientDict = getPatientDetailsFromSalesOrder()
            let patientNo = patientDict.value(forKey: Constants.PM_SYS_ID) as! Int
            if patientNo != 0 {
                let requestModel : RxGlassesModel =  RxGlassesModel()
                let controller : RxGlassesController = RxGlassesController()
                let custNo = patientDict.value(forKey: Constants.TRANS_PATIENT_NO)
                let reqDic : NSMutableDictionary = NSMutableDictionary()
                reqDic.setValue(patientNo, forKey: Constants.PM_SYS_ID)
                reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
                requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_RX_GLASSES)
                let responseModel = controller.performSyncRequest(requestModel) as? RxGlassesModel
                searcResultDic = responseModel!.responseResult
                if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                    performSegue(withIdentifier: "ToCustomerRxGlasses", sender: self)
                } else {
                //present a alret view.
                }
            }
        } else if presTypeVal == "SlitKReadings" {
            let requestModel : SlitKReadingModel =  SlitKReadingModel()
            let controller : SlitKReadingController = SlitKReadingController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_SLIT_K_READING)
            let responseModel = controller.performSyncRequest(requestModel) as? SlitKReadingModel
            searcResultDic = responseModel!.responseResult
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerSlitKReadings", sender: self)
            } else {
                //present a alret view.
            }
        } else if presTypeVal == "TrialDetails" {
            let requestModel : TrailModel =  TrailModel()
            let controller : TrailController = TrailController()
            let sysId = 993552
            let custNo = "013-993552"
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_TRAIL)
            let responseModel = controller.performSyncRequest(requestModel) as? TrailModel
            searcResultDic = responseModel!.responseResult
            if(searcResultDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
                performSegue(withIdentifier: "ToCustomerTrail", sender: self)
            } else {
                //present a alret view.
            }
        }
        
    }
    
    @IBAction func PrescriptionButtonClick(_ sender: AnyObject) {
        //PrescriptionNumberLabel.text = "RXContactLens Number"
        //let cellButton = UIButton(frame: CGRectMake(5, 5, 50, 30))
        //cellButton.setTitle("hello", forState: UIControlState.Normal)
        
        //PrescriptionScrollView.addSubview(cellButton)
        
        //array.append(cellButton)
        
        let popoverContent = PrescriptionTypeController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.txtPrescriptionType = PrescriptiontypeTextField
        popoverContent.lblPrescriptionTypeNumber = PrescriptionNumberLabel
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 150, height: 110)
        popover!.sourceView = PrescriptiontypeTextField
        popover!.sourceRect = PrescriptiontypeTextField.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
          txtPrescriptionNumberField.text = ""
    }
}
