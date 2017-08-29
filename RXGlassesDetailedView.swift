//
//  RXGlassesDetailedView.swift
//  TouchymPOS
//
//  Created by user115796 on 3/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class RXGlassesDetailedView: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var buttonSendMail: UIButton!
    @IBOutlet weak var buttonSelectDate: UIButton!
    @IBOutlet weak var buttonOptimestric: UIButton!
    
    var rxGlassData : NSMutableDictionary = NSMutableDictionary()
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var operationType : String!
    var adminModel = AdminSettingModel.getInstance()
    var parentViewer : CustomerRxGlassesView!
    
    
    @IBOutlet weak var lblCuNo: UILabel!
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblOptimestric: UITextField!
    
    @IBOutlet weak var txtRightEyeSPHDBox: UITextField!
    @IBOutlet weak var txtRightEyeSphNBox: UITextField!
    
    @IBOutlet weak var txtRightEyeCylNBox: UITextField!
    @IBOutlet weak var txtRightEyeCylDBox: UITextField!
    
    @IBOutlet weak var txtRightEyeAxisNBox: UITextField!
    @IBOutlet weak var txtRightEyeAxisDBox: UITextField!
    
    @IBOutlet weak var txtRightEyeVisonNBox: UITextField!
    @IBOutlet weak var txtRightEyeVisionDBox: UITextField!
    
    @IBOutlet weak var txtRightEyeAddBox: UITextField!
    @IBOutlet weak var txtRightEyePdBox: UITextField!
    @IBOutlet weak var txtRightEyePrizmBox: UITextField!
    
    
    @IBOutlet weak var txtLeftEyeSPHDBox: UITextField!
    @IBOutlet weak var txtLeftEyeSphNBox: UITextField!
    
    @IBOutlet weak var txtLeftEyeCylNBox: UITextField!
    @IBOutlet weak var txtLeftEyeCylDBox: UITextField!
    
    @IBOutlet weak var txtLeftEyeAxisNBox: UITextField!
    @IBOutlet weak var txtLeftEyeAxisDBox: UITextField!
    
    @IBOutlet weak var txtLeftEyeVisonNBox: UITextField!
    @IBOutlet weak var txtLeftEyeVisionDBox: UITextField!
    
    @IBOutlet weak var txtLeftEyeAddBox: UITextField!
    @IBOutlet weak var txtLeftEyePdBox: UITextField!
    @IBOutlet weak var txtLeftEyePrizmBox: UITextField!
    
    @IBOutlet weak var txtViewRemarks: UITextView!
    
    @IBOutlet weak var txtCuDate: UITextField!
    
    var currentTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        lblOptimestric.delegate = self
        txtCuDate.delegate = self
        fillData()
        
        lblOptimestric.delegate = self
        txtRightEyeSPHDBox.delegate = self
        txtRightEyeSphNBox.delegate = self
        txtRightEyeCylNBox.delegate = self
        txtRightEyeCylDBox.delegate = self
        txtRightEyeAxisNBox.delegate = self
        txtRightEyeAxisDBox.delegate = self
        txtRightEyeVisonNBox.delegate = self
        txtRightEyeVisionDBox.delegate = self
        txtRightEyeAddBox.delegate = self
        txtRightEyePdBox.delegate = self
        txtRightEyePrizmBox.delegate = self
        txtLeftEyeSPHDBox.delegate = self
        txtLeftEyeSphNBox.delegate = self
        txtLeftEyeCylNBox.delegate = self
        txtLeftEyeCylDBox.delegate = self
        txtLeftEyeAxisNBox.delegate = self
        txtLeftEyeAxisDBox.delegate = self
        txtLeftEyeVisonNBox.delegate = self
        txtLeftEyeVisionDBox.delegate = self
        txtLeftEyeAddBox.delegate = self
        txtLeftEyePdBox.delegate = self
        txtLeftEyePrizmBox.delegate = self
        txtViewRemarks.delegate = self
        txtCuDate.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(RXGlassesDetailedView.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(RXGlassesDetailedView.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)

    }
    
    func keyboardWillHide(_ sender: Notification) {
        if currentTag < Constants.FIELD_SHOULD_EDIT_SHOULD_MOVE {
            return
        }
        currentTag = 0
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += (keyboardSize.height/1.5)
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if currentTag < Constants.FIELD_SHOULD_EDIT_SHOULD_MOVE {
            return
        }
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= (keyboardSize.height/1.5)
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += (keyboardSize.height/1.5) - offset.height
            })
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            lblOptimestric.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == Constants.FIELD_SHOULD_NOT_EDIT {
            return false
        }
        currentTag = textField.tag
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentTag = textView.tag
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func fillData() {
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_DATE) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtCuDate.text =  dateFormatter.string(from: date!)
        }
        
        if let val = customerInfo.value(forKey: Constants.PM_PATIENT_NAME) {
            lblCuName.text = val as? String
        }
        if let val = customerInfo.value(forKey: Constants.PM_CUST_NO) {
            lblCuNo.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_SM_CODE) {
            lblOptimestric.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_N_VISION) {
            txtRightEyeVisonNBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_N_SPH) {
            txtRightEyeSphNBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_N_AXIS) {
            txtRightEyeAxisNBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_N_CYL) {
            txtRightEyeCylNBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_D_VISION) {
            txtRightEyeVisionDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_D_SPH) {
            txtRightEyeSPHDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_D_AXIS) {
            txtRightEyeAxisDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_D_CYL) {
            txtRightEyeCylDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_ADD) {
            txtRightEyeAddBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_PD) {
            txtRightEyePdBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_R_PRIZM) {
            txtRightEyePrizmBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_N_VISION) {
            txtLeftEyeVisonNBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_N_AXIS) {
            txtLeftEyeAxisNBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_N_CYL) {
            txtLeftEyeCylNBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_N_SPH) {
            txtLeftEyeSphNBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_D_VISION) {
            txtLeftEyeVisionDBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_D_CYL) {
            txtLeftEyeCylDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_D_AXIS) {
            txtLeftEyeAxisDBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_D_SPH) {
            txtLeftEyeSPHDBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_ADD) {
            txtLeftEyeAddBox.text = val as? String
        }
        
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_PD) {
            txtLeftEyePdBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_L_PRIZM) {
            txtLeftEyePrizmBox.text = val as? String
        }
        if let val = rxGlassData.value(forKey: Constants.PRXG_REMARK) {
            txtViewRemarks.text = val as? String
        }
    }
    
    func getData( _ resData : NSMutableDictionary) {
        
        if let val = txtCuDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            resData.setValue(dateFormatter.string(from: date!), forKey: Constants.PRXG_DATE)
            //}
        }
        
        if let val = lblOptimestric.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_SM_CODE)
            //}
        }
        
        if let val = txtRightEyeVisonNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_N_VISION)
            //}
        }
        
        if let val = txtRightEyeSphNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_N_SPH)
            //}
        }
        
        if let val = txtRightEyeAxisNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_N_AXIS)
            //}
        }
        
        if let val = txtRightEyeCylNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_N_CYL)
           // }
        }
        
        if let val = txtRightEyeVisionDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_D_VISION)
            //}
        }
        
        if let val = txtRightEyeSPHDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //f !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_D_SPH)
           // }
        }
        
        if let val = txtRightEyeAxisDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_D_AXIS)
            //}
        }
        
        if let val = txtRightEyeCylDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_D_CYL)
            //}
        }
        
        if let val = txtRightEyeAddBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_ADD)
            //}
        }
        
        if let val = txtRightEyePdBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_PD)
            //}
        }
        
        if let val = txtRightEyePrizmBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_R_PRIZM)
            //}
        }
        
        if let val = txtLeftEyeVisonNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_N_VISION)
            //}
        }
        
        if let val = txtLeftEyeAxisNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_N_AXIS)
            //}
        }
        
        if let val = txtLeftEyeCylNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_N_CYL)
            //}
        }
        
        if let val = txtLeftEyeSphNBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_N_SPH)
            //}
        }
        
        if let val = txtLeftEyeVisionDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_D_VISION)
            //}
        }
        
        if let val = txtLeftEyeCylDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_D_CYL)
            //}
        }
        
        if let val = txtLeftEyeAxisDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_D_AXIS)
            //}
        }
        
        if let val = txtLeftEyeSPHDBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           // if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_D_SPH)
            //}
        }
        
        if let val = txtLeftEyeAddBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_ADD)
            //}
        }
        
        if let val = txtLeftEyePdBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_PD)
            //}
        }
        
        if let val = txtLeftEyePrizmBox.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_L_PRIZM)
            //}
        }
        
        if let val = txtViewRemarks.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
                resData.setValue(val, forKey: Constants.PRXG_REMARK)
            //}
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
        let rxGlassModel = RxGlassesModel()
        let adminDic = adminModel.userDataDic
        //let countSetup = adminDic.valueForKey(Constants.COUNT_SETUP) as! NSDictionary
        let reqData = rxGlassData
        if let val = txtCuDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select a value for - 'Date'")
                return
            }
        }
        if let val = lblOptimestric.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select a value for - 'Optimetrist'")
                return
            }
        }
        getData(reqData)
        let controller  = RxGlassesController()
        if operationType == Constants.OPERATION_TYPE_ADD {
            reqData.setValue(adminDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.PRXG_COUNTER_CODE)
            reqData.setValue(adminDic.value(forKey: Constants.COMP_CODE), forKey: Constants.PRXG_COMP_CODE)
            reqData.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.PRXG_LOCN_CODE)
            reqData.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PRXG_CR_UID)
            reqData.setValue(customerInfo.value(forKey: Constants.PM_SYS_ID), forKey: Constants.PRXG_PM_SYS_ID)
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            reqData.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PRXG_UPD_UID)
        }
        
        rxGlassModel.reqeustType.setValue(reqData, forKey: Constants.SAVE_RX_GLASSES_INFO)
        rxGlassModel.reqeustType.setValue(operationType, forKey: Constants.OPERATION_TYPE)
        
        let resRxModel = controller.performSaveOperation(rxGlassModel) as! RxGlassesModel
        var msgTitle :String!
        if operationType == Constants.OPERATION_TYPE_ADD {
            msgTitle = "Add Operation"
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            msgTitle = "Edit Operation"
        } else {
            msgTitle = "Delete Operation"
        }
        
        if resRxModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
            self.rxGlassData = resRxModel.responseResult.value(forKey: "rxGlassObj") as! NSMutableDictionary
            let key = rxGlassData.value(forKey: Constants.PRXG_SYS_ID)!
            parentViewer.rxGlassData.removeObject(forKey: String(describing: key))
            parentViewer.rxGlassData.setValue(rxGlassData, forKey: String(describing: key))
            parentViewer.rxGlassKey = parentViewer.rxGlassData.allKeys as! [String]
            
            showErrorMsg(msgTitle, message: "RX Glasses details \(operationType.lowercased())ed successfully")
        } else {
            showErrorMsg(msgTitle, message: "Error while \(operationType.lowercased())ing RX Glasses details.")
        }
            
    }
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func optimetristTouchUpInside(_ sender: AnyObject) {
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
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func txtDateTouchDown(_ sender: AnyObject) {
        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let popoverContent = storyboard.instantiateViewControllerWithIdentifier("DateViewPopOver") as! DateViewController
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtCuDate
        popover!.sourceRect = txtCuDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCompanyCodeListViewForSalesMan" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            destVc?.parentViewName = Constants.VIEWER_RX_GLASSES_DETAILED_VIEWER
        }
    }
    @IBAction func buttonSendMailTouchUpInside(_ sender: AnyObject) {
        let popoverContent = EmailPopoverView()
        popoverContent.parentType = Constants.RX_GLASS
        if nil == rxGlassData.value(forKey: Constants.PRXG_SYS_ID){
            showErrorMsg("Error", message: "Save the RxGlass Details first, in order to send mail!")
        }else{
            popoverContent.transId = String(rxGlassData.value(forKey: Constants.PRXG_SYS_ID) as! Int)
            if let val = customerInfo.value(forKey: Constants.PM_EMAIL) {
                popoverContent.emailId = val as? String
            }
            let nav = UINavigationController(rootViewController: popoverContent)
            popoverContent.parentView = self
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: 500,height: 100)
            popover!.sourceView = buttonSendMail
            popover!.sourceRect = buttonSendMail.bounds
            popover?.permittedArrowDirections = .any
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonDateTouchUpInside(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = buttonSelectDate
        popover!.sourceRect = buttonSelectDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonOptemistricTouchUpInside(_ sender: AnyObject) {
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
            performSegue(withIdentifier: "ToCompanyCodeListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
}
