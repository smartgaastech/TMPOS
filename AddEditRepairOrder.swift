//
//  AddEditRepairOrder.swift
//  TouchymPOS
//
//  Created by ESHACK on 6/29/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class AddEditRepairOrder: UIViewController, UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var lblRepairOrderNo: UILabel!
    @IBOutlet weak var lblLocationCreated: UILabel!
    @IBOutlet weak var txtRepairOrderDate: UITextField!
    @IBOutlet weak var btnRepairOrderDate: UIButton!
    @IBOutlet weak var txtLocationAssigned: UITextField!
    @IBOutlet weak var btnLocationAssigned: UIButton!
    
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtItemCode: UITextField!
    @IBOutlet weak var txtSalesInvoiceNo: UITextField!
    @IBOutlet weak var txtSalesOrderNo: UITextField!
    @IBOutlet weak var btnSalesOrderInfo: UIButton!
    @IBOutlet weak var txtViewOtherDetails: UITextView!
    @IBOutlet weak var txtViewSpecialInstruction: UITextView!
    @IBOutlet weak var txtCreatedBy: UITextField!
    @IBOutlet weak var btnCreatedBy: UIButton!
    @IBOutlet weak var txtDeliveryDate: UITextField!
    @IBOutlet weak var bntDeliveryDate: UIButton!
    @IBOutlet weak var DynamicControlScrollView: UIScrollView!
    
    @IBOutlet weak var btnOriginalCase: UIButton!
    @IBOutlet weak var lblRepairOrderNumberHead: UILabel!
    @IBOutlet weak var btnUnderWarranty: UIButton!
    
    var parentViewer : UIViewController!
    
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    let adminModel = AdminSettingModel.getInstance()
    var invoiceItems : NSMutableDictionary = NSMutableDictionary()
    var ctlsSelectButtonDictionary : NSMutableDictionary = NSMutableDictionary()
    var ctlsDictionary : NSMutableDictionary = NSMutableDictionary()
    var ctlsObjsDictionary : NSMutableDictionary = NSMutableDictionary()
    var operationType : String!
    var roInfo : NSMutableDictionary!
    var onceOpend = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocationAssigned.delegate = self
        txtCreatedBy.delegate = self
        //need to remove this - check
        //operationType = Constants.OPERATION_TYPE_ADD
        if operationType == Constants.OPERATION_TYPE_ADD {
            lblLocationCreated.text = adminModel.userDataDic.value(forKey: Constants.LOCN_CODE) as? String
        }
        /*if soNo != "" {
            txtSalesOrderNo.text = soNo
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadHighlightDefectControls()
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) {
            txtLocationAssigned.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            txtCreatedBy.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SHOW_INVOICE_ITEMS) {
            txtItemCode.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
            txtItemName.text = invoiceItems.value(forKey: txtItemCode.text!) as! String
        }else if onceOpend {
            
            fillData()
            onceOpend = false
        }
        btnUnderWarranty.setImage(UIImage(named: "uncheckImage"), for: UIControlState.normal)
        btnUnderWarranty.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
        btnOriginalCase.setImage(UIImage(named: "uncheckImage"), for: UIControlState.normal)
        btnOriginalCase.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
        
        
    }
    
    func fillData() {
        if let val = roInfo?.value(forKey: Constants.JRH_NO) {
            let tempVal = val
            lblRepairOrderNo.text = String(describing: tempVal)
        }
        if let val = roInfo?.value(forKey: Constants.JRH_LOCN_CODE) {
            lblLocationCreated.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_CR_DT) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtRepairOrderDate.text = dateFormatter.string(from: date!)
        }
        if let val = roInfo?.value(forKey: Constants.TPOSROD_LOCN_ASSIGNED) {
            txtLocationAssigned.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_REF_NO) {
            let tempVal = val
            txtSalesOrderNo.text = String(describing: tempVal)
        }
        if let val = roInfo?.value(forKey: Constants.TPOSROD_OPTIMETRIST) {
            txtCreatedBy.text = val as? String
        }
        
        if let val = roInfo?.value(forKey: Constants.TPOSROD_DELIVERY_DATE) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtDeliveryDate.text = dateFormatter.string(from: date!)
        }
        if let val = roInfo?.value(forKey: Constants.JRH_REMARKS) {
            txtViewSpecialInstruction.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRD_REMARKS) {
            txtViewOtherDetails.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_INVOICE_NO) {
            let tempVal = val
            txtSalesInvoiceNo.text = String(describing: tempVal)
        }
        if let val = roInfo?.value(forKey: Constants.JRH_INVOICE_ITEM_CODE) {
            txtItemCode.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_ITEM_WARRANTY) {
            let tempVal = val
            if tempVal as! String == "Yes" {
                btnUnderWarranty.isSelected = true
            }
        }
        if let val = roInfo?.value(forKey: Constants.JRH_ORIGINAL_CASE) {
            let tempVal = val
            if tempVal as! String == "Yes" {
                btnOriginalCase.isSelected = true
            }
        }
        
        let ctlDic = ctlsDictionary
        for (key,ctls) in ctlDic {
            if ctls is UISwitch {
                let tempSwitch = ctls as! UISwitch
                if let val = roInfo?.value(forKey: "TPOSROD_FLEX_" + (key as! String)){
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
                let val = roInfo?.value(forKey: "TPOSROD_FLEX_" + (key as! String))
                if val != nil {
                    tempTextview.text = val as! String
                }
            } else if ctls is UITextField {
                let tempTextField = ctls as! UITextField
                let val = roInfo?.value(forKey: "TPOSROD_FLEX_" + (key as! String))
                if val != nil {
                    tempTextField.text = val as! String
                }
            } else if ctls is NSMutableDictionary {
                let tempDic =  ctls as! NSMutableDictionary
                let rightbtn = tempDic.value(forKey: "right") as! UIButton
                let leftbtn = tempDic.value(forKey: "left") as! UIButton
                let dicval = roInfo?.value(forKey: "TPOSROD_FLEX_" + (key as! String))
                if dicval != nil {
                    let val = roInfo?.value(forKey: "TPOSROD_FLEX_" + (key as! String)) as! String
                    let splitvalues = val.components(separatedBy: ",")
                    var rightval: String = splitvalues[0]
                    var leftval: String = splitvalues[1]
                    if rightval == "Yes" {
                        rightbtn.addTarget(self, action: #selector(checkboxBtnCaseAction), for: .touchUpInside)
                        rightbtn.isSelected = true
                        rightbtn.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
                    }
                    if leftval == "Yes" {
                        leftbtn.addTarget(self, action: #selector(checkboxBtnCaseAction), for: .touchUpInside)
                        leftbtn.isSelected = true
                        leftbtn.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
                    }
                }
            }
        }
    }
    
    func loadHighlightDefectControls(){
        do {
            ctlsDictionary = NSMutableDictionary()
            ctlsSelectButtonDictionary = NSMutableDictionary()
            let subViews = self.DynamicControlScrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            let repairordermodel = RepairOrderModel()
            let controller = RepairOrderController()
            let searchReq = NSMutableDictionary()
            DynamicControlScrollView.showsVerticalScrollIndicator = true
            searchReq.setValue("DefectedParts",  forKey: Constants.DYN_VISIT_TYPE)
            repairordermodel.requestType.setValue(searchReq, forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE)
            let resModel = controller.performSyncRequest(repairordermodel) as! RepairOrderModel
            let dynCtrlObj = resModel.responseResult.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) as! NSMutableDictionary
            let dynControlItems = dynCtrlObj.value(forKey: Constants.DYN_CTLS) as! NSMutableDictionary
            let dynControlsCount = dynCtrlObj.value(forKey: Constants.DYN_CTLS_NUMBER) as! NSInteger
            
            if (dynControlsCount>0) {
                ctlsObjsDictionary = dynControlItems
                
                var x = 15
                var y = 1
                var GroupName = ""
                var lastRightLeftCheckbox = false
                var lastSwitch = false
                var lastTextType = false
                //for var index = 1; index <= dynControlsCount; index += 1 {
                for index in stride(from: 1, to: dynControlsCount+1, by: 1){
                    let controlDef = dynControlItems.value(forKey: String(index)) as! NSMutableDictionary
                    var controlType = controlDef.value(forKey: Constants.CTL_TYPE) as! String
                    var mappedField = controlDef.value(forKey: Constants.CTL_MAPPED_FIELD)
                    if controlType == Constants.CTL_RIGHTLEFT_CHECKBOX {
                        if (controlDef.value(forKey: Constants.CTL_GROUP) as AnyObject).lowercased == "yes" && (GroupName == "" ||  GroupName != controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String ){
                            if lastRightLeftCheckbox {
                                y = y + 45
                            }else {
                                lastRightLeftCheckbox = true
                            }
                            GroupName = controlDef.value(forKey: Constants.CTL_GROUP_NAME) as! String
                            let labelCtlHeader = UILabel(frame: CGRect(x: 2, y: CGFloat(y), width: 1020, height: 30))
                            labelCtlHeader.text = " " + GroupName
                            labelCtlHeader.backgroundColor = UIColor(red: 0.5, green: 190.0/255.0, blue: 0.5, alpha: 1.0)
                            labelCtlHeader.textColor = UIColor.white
                            labelCtlHeader.font = UIFont(name: "Hoefler Text", size: 17)
                            DynamicControlScrollView.addSubview(labelCtlHeader)
                        }
                        y = y + 45
                        x = 15
                        
                        let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                        let labelCtl = UILabel(frame: CGRect(x: CGFloat(x + 60), y: CGFloat(y), width: 200, height: 30))
                        labelCtl.text = labelName
                        labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        labelCtl.textColor = lblRepairOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelCtl)
                        
                        let labelRightCtl = UILabel(frame: CGRect(x: CGFloat(x + 265), y: CGFloat(y), width: 50, height: 30))
                        labelRightCtl.text = "Right"
                        labelRightCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        labelRightCtl.textColor = lblRepairOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelRightCtl)
                        
                        let rightbtn  = UIButton(frame: CGRect(x: CGFloat(x + 325), y: CGFloat(y), width: 27, height: 25))
                        rightbtn.setImage(UIImage(named: "uncheckImage"), for: UIControlState.normal)
                        rightbtn.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
                        rightbtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
                        rightbtn.addTarget(self, action: #selector(checkboxBtnCaseAction), for: .touchUpInside)
                        DynamicControlScrollView.addSubview(rightbtn)
                        
                        let labelLefttCtl = UILabel(frame: CGRect(x: CGFloat(x + 405), y: CGFloat(y), width: 50, height: 30))
                        labelLefttCtl.text = "Left"
                        labelLefttCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        labelLefttCtl.textColor = lblRepairOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelLefttCtl)
                        
                        let leftbtn  = UIButton(frame: CGRect(x: CGFloat(x + 465), y: CGFloat(y), width: 27, height: 25))
                        leftbtn.setImage(UIImage(named: "uncheckImage"), for: UIControlState.normal)
                        leftbtn.setImage(UIImage(named: "UserCheck"), for: UIControlState.selected)
                        leftbtn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
                        leftbtn.addTarget(self, action: #selector(checkboxBtnCaseAction), for: .touchUpInside)
                        DynamicControlScrollView.addSubview(leftbtn)
                        
                        let previewBtn  = UIButton(frame: CGRect(x: CGFloat(x + 525), y: CGFloat(y), width: 80, height: 25))
                        previewBtn.setTitle("Preview", for: .normal)
                        previewBtn.setTitleColor(UIColor(red: 0, green: 190.0/255.0, blue: 0.5, alpha: 1.0), for: .normal)
                        previewBtn.backgroundColor = UIColor(red: 0.6, green: 190.0/255.0, blue: 0.7, alpha: 1.0)
                        previewBtn.addTarget(self, action: #selector(previewBtnAction), for: .touchUpInside)
                        previewBtn.tag = index
                        DynamicControlScrollView.addSubview(previewBtn)
                        
                        let rightLeftCheckboxDic = NSMutableDictionary()
                        rightLeftCheckboxDic.setValue(rightbtn, forKey: "right")
                        rightLeftCheckboxDic.setValue(leftbtn, forKey: "left")
                        ctlsDictionary[mappedField] = rightLeftCheckboxDic
                        
                    }else if controlType as! String  == Constants.CTL_SWITCH_TYPE {
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
                            DynamicControlScrollView.addSubview(labelCtlHeader)
                            y = y + 40
                        }
                        let switchCtl = UISwitch(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 50, height: 30))
                        switchCtl.addTarget(self, action: #selector(AddEditWorkOrder.swithValueChanged(_:)), for: UIControlEvents.valueChanged)
                        switchCtl.tag = index
                        DynamicControlScrollView.addSubview(switchCtl)
                        let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                        let labelCtl = UILabel(frame: CGRect(x: CGFloat(x + 60), y: CGFloat(y), width: 220, height: 30))
                        labelCtl.text = labelName
                        labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        //labelCtl.textColor = lblWorkOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelCtl)
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
                            DynamicControlScrollView.addSubview(labelCtlHeader)
                        }
                        y = y + 45
                        x = 15
                        let labelName = controlDef.value(forKey: Constants.CTL_NAME) as! String
                        let labelCtl = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 150, height: 30))
                        labelCtl.text = labelName
                        labelCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        //labelCtl.textColor = lblWorkOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelCtl)
                        let textAreaCtl = UITextView(frame: CGRect(x: CGFloat(x + 181), y: CGFloat(y), width: 720, height: 60))
                        textAreaCtl.isScrollEnabled = true
                        textAreaCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        DynamicControlScrollView.addSubview(textAreaCtl)
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
                            DynamicControlScrollView.addSubview(labelCtlHeader)
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
                        //labelCtl.textColor = lblWorkOrderNumberHead.textColor
                        DynamicControlScrollView.addSubview(labelCtl)
                        let textFieldCtl = UITextField(frame: CGRect(x: CGFloat(x + 181), y: CGFloat(y), width: 250, height: 30))
                        textFieldCtl.layer.cornerRadius = 3
                        textFieldCtl.font = UIFont(name: "Hoefler Text", size: 17)
                        //textFieldCtl.addTarget(self, action: "txtFieldEditingDidEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
                        textFieldCtl.tag = index
                        //textFieldCtl.borderStyle = UITextBorderStyle.Line
                        textFieldCtl.backgroundColor = UIColor.white
                        DynamicControlScrollView.addSubview(textFieldCtl)
                        if controlType as! String == Constants.CTL_DROPDOWN {
                            let btn = UIButton(type: UIButtonType.custom) as UIButton
                            btn.frame = CGRect(x: CGFloat(x + 408), y: CGFloat(y + 3), width: 20, height: 25)
                            btn.setImage(UIImage(named: "DropDown.png"), for: UIControlState())
                            btn.addTarget(self, action: #selector(AddEditWorkOrder.btnDropDownTouchedUpInside(_:)), for: UIControlEvents.touchUpInside)
                            btn.tag = index
                            DynamicControlScrollView.addSubview(btn)
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
                DynamicControlScrollView.contentSize = CGSize(width: 1024, height: CGFloat(y + 50))
            }
            
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func checkboxBtnCaseAction(sender: UIButton!){
        if sender.isSelected == true {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    func previewBtnAction(sender: UIButton!){
        let popoverContent = PopupImageViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 800, height: 600)
        
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popover!.sourceView = self.view
        let a = sender.tag
        
        let tempCtlDic = ctlsObjsDictionary.value(forKey: String(a)) as! NSMutableDictionary
        var tempName = tempCtlDic.value(forKey: Constants.CTL_NAME) as! String
        var truncated = tempName.substring(to: tempName.index(before: tempName.endIndex))
        var image = truncated.replacingOccurrences(of: "(", with: "_").replacingOccurrences(of: " ", with: "_") + ".png"
        popoverContent.imageName = image
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnOriginalCaseAction(_ sender: Any) {
        if btnOriginalCase.isSelected == true {
            btnOriginalCase.isSelected = false
        }else {
            btnOriginalCase.isSelected = true
        }
    }
    
    @IBAction func btnUnderWarrantyAction(_ sender: Any) {
        if btnUnderWarranty.isSelected == true {
            btnUnderWarranty.isSelected = false
        }else {
            btnUnderWarranty.isSelected = true
        }
    }
    
    @IBAction func btnSaveRepairOrder(_ sender: Any) {
        
        let roModel = RepairOrderModel()
        
        if operationType == Constants.OPERATION_TYPE_VIEW {
            showErrorMsg("Cannot be modified!", message: "Only Viewing is permitted!")
            barButtonSave.isEnabled = false
            return
        }
        
        if operationType == Constants.OPERATION_TYPE_ADD && roInfo == nil {
            roInfo = NSMutableDictionary()
        }
        let adminDic = adminModel.userDataDic
        
        if operationType == Constants.OPERATION_TYPE_EDIT {
            if let val = roInfo.value(forKey: Constants.JRD_STATUS_CODE) {
                if val as! String == "001" {
                }else{
                    showErrorMsg("RepairOrder Cannot be updated", message: "Workshop has changed status for this Repair Order")
                    return
                }
            }
            var rolocn = roInfo.value(forKey: Constants.JRH_LOCN_CODE) as! String
            let curlocn = adminDic.value(forKey: Constants.LOCN_CODE) as! String
            if curlocn != rolocn {
                showErrorMsg("RepairOrder Cannot be edited", message: "Repair Order is created by another location!")
                return
                
            }
        }
        
        let countSetup = adminDic.value(forKey: Constants.COUNT_SETUP) as! NSDictionary
        
        if let val = txtRepairOrderDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select RepairOrder Date!")
                return
            }
        }
        var salesOrderEntered = true
        var invoiceEntered = true
        var itemSelected = true
        var warranty = true
        var origcase = true
        if let val = txtSalesOrderNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                salesOrderEntered = false
                //showErrorMsg("Mandatory Field!", message: "Please enter SalesOrder!")
                //return
            }
            // add code to check salesorder is valid and patient is linked
        }
        if let val = txtLocationAssigned.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please enter Location this RepairOrder is Assigned!")
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
        if let val = txtDeliveryDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                showErrorMsg("Mandatory Field!", message: "Please select expected Delivery Date!")
                return
            }
        }
        if let val = txtSalesInvoiceNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                //showErrorMsg("Mandatory Field!", message: "Please select Sales Invoice No.")
                //return
                invoiceEntered = false
            }
        }
        if let val = txtItemCode.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimedSt.isEmpty {
                //showErrorMsg("Mandatory Field!", message: "Please select Item.")
                //return
                itemSelected = false
            }
        }
        
        if btnUnderWarranty.isSelected {
            warranty = true
        }else{
            warranty = false
        }
        if btnOriginalCase.isSelected {
            origcase = true
        }else{
            origcase = false
        }
        
        if (!warranty || !origcase) && invoiceEntered && salesOrderEntered{
            showErrorMsg("Error!", message: "Please enter either of Sales Order or Invoice Number and not both")
            return
        }
        if (warranty || origcase) && !invoiceEntered {
            showErrorMsg("Mandatory Field!", message: "Please select Sales Invoice No.")
            return
        }
        if (!warranty || !origcase) && !invoiceEntered && !salesOrderEntered {
            showErrorMsg("Mandatory Field!", message: "Please enter Sales Order or Invoice Number!")
            return
        }
        if (warranty || origcase) && invoiceEntered && !itemSelected {
            showErrorMsg("Mandatory Field!", message: "Please select Item.")
            return
        }
        
        getValues(roInfo)
        
        let controller = RepairOrderController()
        
        if operationType == Constants.OPERATION_TYPE_ADD {
            roInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JRH_CR_UID)
            roInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JRD_CR_UID)
            roInfo.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JRH_UPD_UID)
            roInfo.setValue(adminDic.value(forKey: Constants.COMP_CODE), forKey: Constants.JRH_COMP_CODE)
            roInfo.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.JRH_LOCN_CODE)
            roInfo.setValue("0", forKey: Constants.JRH_NO)
            roInfo.setValue("SO", forKey: Constants.JRH_REF_TXN_CODE)
            roInfo.setValue("N", forKey: Constants.JRH_COMPLETED_YN)
            let patientDict = getPatientDetailsFromSalesOrder()
            let patientNo = patientDict.value(forKey: Constants.PM_SYS_ID) as! Int
            roInfo.setValue(patientNo, forKey: Constants.JRH_PM_SYS_ID)
            roInfo.setValue(patientDict.value(forKey: Constants.TRANS_PATIENT_NO), forKey: Constants.JRH_PATIENT_ID)
        }
        
        roModel.requestType.setValue(roInfo, forKey: Constants.SAVE_REPAIR_ORDER)
        roModel.requestType.setValue(operationType, forKey: Constants.OPERATION_TYPE)
        
        let resRoModel = controller.performSaveOperation(roModel) as! RepairOrderModel
        
        var msgTitle :String!
        if operationType == Constants.OPERATION_TYPE_ADD {
            msgTitle = "created"
            
        } else if operationType == Constants.OPERATION_TYPE_EDIT {
            msgTitle = "edited"
        } else {
            msgTitle = "Delete Operation"
        }
        if resRoModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
            self.roInfo = resRoModel.responseResult.value(forKey: Constants.SAVE_REPAIR_ORDER_INFO) as? NSMutableDictionary
            var msg = "RepairOrder Saved Successfully"
            showErrorMsg(msgTitle, message: msg)
            //showYesNoValidatorToSummarize("Successfully " + msgTitle  + "!", message: "You can view the summary by clicking 'Show Summary'")
        } else {
            showErrorMsg(msgTitle, message: "Error while Saving RepairOrder.")
        }
    }

    func getValues(_ roInfos : NSMutableDictionary) {
        
        if btnUnderWarranty.isSelected {
            roInfos.setValue("Yes", forKey: Constants.JRH_ITEM_WARRANTY)
        }else{
            roInfos.setValue("No", forKey: Constants.JRH_ITEM_WARRANTY)
        }
        
        if btnOriginalCase.isSelected {
            roInfos.setValue("Yes", forKey: Constants.JRH_ORIGINAL_CASE)
        }else{
            roInfos.setValue("No", forKey: Constants.JRH_ORIGINAL_CASE)
        }
        
        if let val = txtRepairOrderDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            roInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.JRH_DT)
            //}
        }
        if let val = lblLocationCreated.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.JRH_LOCN_CODE)
        }
        if let val = txtLocationAssigned.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.TPOSROD_LOCN_ASSIGNED)
        }
        if let val = txtSalesOrderNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.JRH_REF_NO)
            //need to update so ref sys id in API itself - imp
            roInfos.setValue(val, forKey: Constants.JRH_REF_SYS_ID)
        }
        if let val = txtSalesInvoiceNo.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.JRH_INVOICE_NO)
        }
        if let val = txtItemCode.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val, forKey: Constants.JRH_INVOICE_ITEM_CODE)
        }
        if let val = txtCreatedBy.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.TPOSROD_OPTIMETRIST)
        }
        if let val = txtDeliveryDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            roInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.TPOSROD_DELIVERY_DATE)
        }
        if let val = txtViewSpecialInstruction.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.JRH_REMARKS)
        }
        if let val = txtViewOtherDetails.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.JRD_REMARKS)
        }
        
        let ctlDic = ctlsDictionary
        for (key,ctls) in ctlDic {
            if ctls is NSMutableDictionary {
                let tmpBtnsDic = ctls as! NSMutableDictionary
                let rBtn = tmpBtnsDic.value(forKey: "right") as! UIButton
                let lBtn = tmpBtnsDic.value(forKey: "left") as! UIButton
                var tempStr = ""
                if rBtn.isSelected {
                    tempStr = "Yes"
                }else{
                    tempStr = "No"
                }
                if lBtn.isSelected {
                    tempStr = tempStr + ",Yes"
                }else{
                    tempStr = tempStr + ",No"
                }
                roInfos.setValue(tempStr, forKey: "TPOSROD_FLEX_" + (key as! String))
            }
        }
        
    }
    
    func getPatientDetailsFromSalesOrder() -> NSMutableDictionary {
        let set = CharacterSet(charactersIn: " .?")
        let patientDic = NSMutableDictionary()
        patientDic.setValue(0, forKey: Constants.PM_SYS_ID)
        let workordermodel = WorkOrderModel()
        let controller = WorkOrderController()
        let searchReq = NSMutableDictionary()
        //PrescriptionScrollView.showsVerticalScrollIndicator = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLocationAssignedRepairOrder" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
        
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_LOCATION_CODE
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_ADD_EDIT_VIEWER
        } else if segue.identifier == "ToItemDetailsRepairOrder" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SHOW_INVOICE_ITEMS
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_ADD_EDIT_VIEWER
        } else if segue.identifier == "ToCreatedByRepairOrder" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_ADD_EDIT_VIEWER
        }else if segue.identifier == "TOSalesOrderView" {
            let destVc = segue.destination as? CustomerHistorySalesOrderView
            destVc?.invoiceData = searcResultDic
            let val = searcResultDic.value(forKey: Constants.TRANS_ITEMS)
            //Need to handle this later
            if val is NSArray {
                destVc?.invoiceTableKey = searcResultDic.value(forKey: Constants.TRANS_ITEMS) as! [NSDictionary]
            }
            destVc?.parentViewName = "AddEditRepairOrder"
        }else if segue.identifier == "TOSalesInvoiceView" {
            let destVc = segue.destination as? CustomerHistoryInvoiceView
            destVc?.invoiceData = searcResultDic
            let val = searcResultDic.value(forKey: Constants.TRANS_ITEMS)
            //Need to handle this later
            if val is NSArray {
                destVc?.invoiceTableKey = searcResultDic.value(forKey: Constants.TRANS_ITEMS) as! [NSDictionary]
            }
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_ADD_EDIT_VIEWER
        }
    }
    
    
    @IBAction func txtItemCodeTouchUpInside(_ sender: Any) {
        let repairordermodel = RepairOrderModel()
        let controller = RepairOrderController()
        let searchReq = NSMutableDictionary()
        //PrescriptionScrollView.showsVerticalScrollIndicator = true
        let txtItemCode = self.txtSalesInvoiceNo.text
        let set = CharacterSet(charactersIn: " .?")
        let trimString = txtItemCode!.trimmingCharacters(in: set)
        if trimString == "" {
            showErrorMsg("Value Required", message: "Please enter the Sales Invoice No.!")
        }else{
            searchReq.setValue(txtSalesInvoiceNo.text,  forKey: Constants.TRANS_NO)
            repairordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
            let resModel = controller.performSyncRequest(repairordermodel) as! RepairOrderModel
            let resDic = resModel.responseResult
            if(resDic.value(forKey: Constants.ERROR_RESPONSE) as! String != "nil") {
                searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) as! NSMutableDictionary
                var dataArrays = NSMutableArray()
                dataArrays = searcResultDic.value(forKey: Constants.TRANS_ITEMS) as! NSMutableArray!
                searcResultDic = NSMutableDictionary()
                for dataArray in dataArrays {
                    let tempDic = dataArray as! NSMutableDictionary
                    searcResultDic.setValue(tempDic.value(forKey: Constants.ITEM_NAME), forKey: tempDic.value(forKey: Constants.ITEM_CODE) as! String)
                }
                invoiceItems = searcResultDic
                performSegue(withIdentifier: "ToItemDetailsRepairOrder", sender: self)
            } else {
                showErrorMsg("Sorry, unable to find the Sales Invoice,!", message: "Please check the Sales Invoice Number entered!")
                txtSalesInvoiceNo.text = ""
            }
        }
    }
    
    
    @IBAction func btnRepairOrderDateTouchUpInside(_ sender: Any) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtRepairOrderDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtRepairOrderDate
        popover!.sourceRect = txtRepairOrderDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnDeliveryDateTouchUpInside(_ sender: Any) {
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
    
    @IBAction func txtRepairOrderDateTouchDown(_ sender: Any) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtRepairOrderDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 400)
        popover!.sourceView = txtRepairOrderDate
        popover!.sourceRect = txtRepairOrderDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func btnLocationAssignedTouchUpInside(_ sender: Any) {
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
            performSegue(withIdentifier: "ToLocationAssignedRepairOrder", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func txtLocationAssignedTouchDown(_ sender: Any) {
        
    }
    
    @IBAction func txtCreatedByTouchDown(_ sender: Any) {
        
    }
    
    @IBAction func btnCreatedByTouchUpInside(_ sender: Any) {
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
            performSegue(withIdentifier: "ToCreatedByRepairOrder", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnSalesOrderInfoTouchUpInside(_ sender: Any) {
        let soNumber = txtSalesOrderNo.text
        let set = CharacterSet(charactersIn: " .?")
        let trimString = soNumber!.trimmingCharacters(in: set)
        if trimString == "" {
            showErrorMsg("Value Required", message: "Please enter the Sales Order No.!")
        }else{
            let repairordermodel = RepairOrderModel()
            let controller = RepairOrderController()
            let searchReq = NSMutableDictionary()
            //PrescriptionScrollView.showsVerticalScrollIndicator = true
            searchReq.setValue(txtSalesOrderNo.text,  forKey: Constants.TRANS_NO)
            repairordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
            let resModel = controller.performSyncRequest(repairordermodel) as! RepairOrderModel
            let resDic = resModel.responseResult
            if(resDic.value(forKey: Constants.ERROR_RESPONSE) as! String != "nil") {
                searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) as! NSMutableDictionary
                performSegue(withIdentifier: "TOSalesOrderView", sender: self)
            } else {
                showErrorMsg("Sorry, unable to find the Sales Order!", message: "Please check the Sales Order Number: entered!")
                txtSalesOrderNo.text = ""
            }
        }
    }
    
    @IBAction func btnSalesInvoiceInfoTouchUpInside(_ sender: Any) {
        let sinvNumber = txtSalesInvoiceNo.text
        let set = CharacterSet(charactersIn: " .?")
        let trimString = sinvNumber!.trimmingCharacters(in: set)
        if trimString == "" {
            showErrorMsg("Value Required", message: "Please enter the Sales Invoice No.!")
        }else{
            let repairordermodel = RepairOrderModel()
            let controller = RepairOrderController()
            let searchReq = NSMutableDictionary()
            searchReq.setValue(sinvNumber,  forKey: Constants.TRANS_NO)
            repairordermodel.requestType.setValue(searchReq, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
            let resModel = controller.performSyncRequest(repairordermodel) as! RepairOrderModel
            let resDic = resModel.responseResult
            if(resDic.value(forKey: Constants.ERROR_RESPONSE) as! String != "nil") {
                searcResultDic = resDic.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) as! NSMutableDictionary
                performSegue(withIdentifier: "TOSalesInvoiceView", sender: self)
            } else {
                showErrorMsg("Sorry, unable to find the Sales Invoice,!", message: "Please check the Sales Invoice Number entered!")
                txtSalesInvoiceNo.text = ""
            }
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
    
    
}
