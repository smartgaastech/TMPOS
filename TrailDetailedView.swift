//
//  TrailDetailedView.swift
//  TouchymPOS
//
//  Created by user115796 on 3/16/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class TrailDetailedView: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var buttonSendMail: UIButton!
    @IBOutlet weak var buttonSelecteDate: UIButton!
    
    var trailData : NSMutableDictionary = NSMutableDictionary()
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var buttonOptimetrist: UIButton!
    
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var operationType : String!
    var adminModel = AdminSettingModel.getInstance()
    var parentViewer : CustomerTrailViewer!
    
    @IBOutlet weak var lblCuNo: UILabel!
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblOptimestric: UITextField!
    
    @IBOutlet weak var txtTLUsedRightEyeBox: UITextField!
    @IBOutlet weak var txtTLUsedRightEyeAddBox: UITextField!
    @IBOutlet weak var txtTLUsEDRightEyeViaBox: UITextField!
    
    @IBOutlet weak var txtTLUsedLeftEyeBox: UITextField!
    @IBOutlet weak var txtTLUsedLeftEyeAddBox: UITextField!
    @IBOutlet weak var txtTLUsedLeftEyeViaBox: UITextField!
    
    @IBOutlet weak var txtTrailRemarksRightEyeBox: UITextField!
    @IBOutlet weak var txtTraiRemarksLeftEyeBox: UITextField!
    
    @IBOutlet weak var txtRemarsBox: UITextView!
    
    @IBOutlet weak var txtCuDate: UITextField!
    
    var currentTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        lblOptimestric.delegate = self
        txtTLUsedRightEyeBox.delegate = self
        txtTLUsedRightEyeAddBox.delegate = self
        txtTLUsEDRightEyeViaBox.delegate = self
        txtTLUsedLeftEyeBox.delegate = self
        txtTLUsedLeftEyeAddBox.delegate = self
        txtTLUsedLeftEyeViaBox.delegate = self
        txtTrailRemarksRightEyeBox.delegate = self
        txtTraiRemarksLeftEyeBox.delegate = self
        txtRemarsBox.delegate = self
        txtCuDate.delegate = self
        
        fillData()
        NotificationCenter.default.addObserver(self, selector: #selector(TrailDetailedView.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(TrailDetailedView.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            lblOptimestric.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fillData() {
        if let val = trailData.value(forKey: Constants.PRXTD_DATE) {
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
        if let val = trailData.value(forKey: Constants.PRXTD_SM_CODE) {
            lblOptimestric.text = val as? String
        }
        
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_LE_ADD) {
            txtTLUsedLeftEyeAddBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_LE) {
            txtTLUsedLeftEyeBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_LE_VIA) {
            txtTLUsedLeftEyeViaBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_RE_ADD) {
            txtTLUsedRightEyeAddBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_RE) {
            txtTLUsedRightEyeBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LENS_USED_RE_VIA) {
            txtTLUsEDRightEyeViaBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_RE_REMARKS) {
            txtTrailRemarksRightEyeBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_LE_REMARKS) {
            txtTraiRemarksLeftEyeBox.text = val as? String
        }
        if let val = trailData.value(forKey: Constants.PRXTD_REMARK) {
            txtRemarsBox.text = val as? String
        }
        
    }
    
    func getData() {
        
        if let val = txtCuDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty && val != "0" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            trailData.setValue(dateFormatter.string(from: date!), forKey: Constants.PRXTD_DATE)
            //}
        }
        
        if let val = lblOptimestric.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_SM_CODE)
        //}
        }
        if let val = txtTLUsedLeftEyeAddBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_LE_ADD)
        //}
        }
        
        
        if let val = txtTLUsedLeftEyeBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_LE)
        //}
        }
        
        
        if let val = txtTLUsedLeftEyeViaBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_LE_VIA)
        //}
        }
        
        
        if let val = txtTLUsedRightEyeAddBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_RE_ADD)
        //}
        }
        
        
        if let val = txtTLUsedRightEyeBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_RE)
        //}
        }
        
        if let val = txtTLUsEDRightEyeViaBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LENS_USED_RE_VIA)
        //}
        }
        
        if let val = txtTrailRemarksRightEyeBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_RE_REMARKS)
        //}
        }
        
        if let val = txtTraiRemarksLeftEyeBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_LE_REMARKS)
        //}
        }
        
        if let val = txtRemarsBox.text {
        let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if !trimedSt.isEmpty {
        trailData.setValue(val, forKey: Constants.PRXTD_REMARK)
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
            let tmodel = TrailModel()
            let adminDic = adminModel.userDataDic
            //let countSetup = adminDic.valueForKey(Constants.COUNT_SETUP) as! NSDictionary
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
            getData()
            let controller  = TrailController()
            if operationType == Constants.OPERATION_TYPE_ADD {
            trailData.setValue(adminDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.PRXTD_COUNTER_CODE)
            trailData.setValue(adminDic.value(forKey: Constants.COMP_CODE), forKey: Constants.PRXTD_COMP_CODE)
            trailData.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.PRXTD_LOCN_CODE)
            trailData.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PRXTD_CR_UID)
            trailData.setValue(customerInfo.value(forKey: Constants.PM_SYS_ID), forKey: Constants.PRXTD_PM_SYS_ID)
            } else if operationType == Constants.OPERATION_TYPE_EDIT {
             trailData.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.PRXTD_UPD_UID)
        }
            
            tmodel.reqeustType.setValue(trailData, forKey: Constants.SAVE_RX_TRAIL_INFO)
            tmodel.reqeustType.setValue(operationType, forKey: Constants.OPERATION_TYPE)
            
            let resModel = controller.performSaveOperation(tmodel) as! TrailModel
            var msgTitle :String!
            if operationType == Constants.OPERATION_TYPE_ADD {
            msgTitle = "Add Operation"
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            msgTitle = "Edit Operation"
        } else {
            msgTitle = "Delete Operation"
            }
            
            if resModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
                self.trailData = resModel.responseResult.value(forKey: "rxTrialObj") as! NSMutableDictionary
                let key = trailData.value(forKey: Constants.PRXTD_SYS_ID)!
                parentViewer.trailData.removeObject(forKey: String(describing: key))
                parentViewer.trailData.setValue(trailData, forKey: String(describing: key))
                parentViewer.trailKey = parentViewer.trailData.allKeys as! [String]
                
            showErrorMsg(msgTitle, message: "Trial details \(operationType.lowercased())ed successfully")
        } else {
            showErrorMsg(msgTitle, message: "Error while \(operationType.lowercased())ing Trail details.")
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ToCompanyCodeListViewForSalesMan" {
                let destVc = segue.destination as? CompanyCodeListView
                destVc?.dataDic = searcResultDic
                destVc?.parentView = self
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
                destVc?.parentViewName = Constants.VIEWER_RX_TRAIL_DETAILED_VIEWER
                }
    }
    
    @IBAction func txtCuDateTouchDown(_ sender: AnyObject) {
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
    
    @IBAction func buttonSendMailTouchUpInside(_ sender: AnyObject) {
        if nil == trailData.value(forKey: Constants.PRXTD_SYS_ID){
            showErrorMsg("Error", message: "Save the Trial Details first, in order to send mail!")
        }else{
            let popoverContent = EmailPopoverView()
            let nav = UINavigationController(rootViewController: popoverContent)
            popoverContent.parentView = self
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: 500,height: 100)
            popover!.sourceView = buttonSendMail
            popover!.sourceRect = buttonSendMail.bounds
            popover?.permittedArrowDirections = .any
            popoverContent.parentType = Constants.TRAIL
            popoverContent.transId = String(trailData.value(forKey: Constants.PRXTD_SYS_ID) as! Int)
            if let val = customerInfo.value(forKey: Constants.PM_EMAIL) {
                popoverContent.emailId = val as? String
            }
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
        popover!.sourceView = buttonSelecteDate
        popover!.sourceRect = buttonSelecteDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonOptimetristTouchUpInside(_ sender: AnyObject) {
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
