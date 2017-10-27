//
//  RepairOrderDetails.swift
//  TouchymPOS
//
//  Created by ESHACK on 7/31/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit


class RepairOrderDetails: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var roInfo : NSMutableDictionary!
    var parentViewer : UIViewController!
    
    @IBOutlet weak var txtViewRemarks: UITextView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtStatusCode: UITextField!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblSalesOrderNo: UILabel!
    @IBOutlet weak var lblLocationCreated: UILabel!
    @IBOutlet weak var lblWorkOrderDate: UILabel!
    
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    let adminModel = AdminSettingModel.getInstance()
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var searchkeyResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.isScrollEnabled = true
        self.tableview.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var tempbool = true
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS) {
            txtStatusCode.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
            tempbool = false
        }else {
            fillData()
            let roInfos = NSMutableDictionary()
            roInfos.setValue(roInfo.value(forKey: Constants.JRH_NO), forKey: Constants.JRH_NO)
            updateRepairOrderStatuses(roInfos)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairOrderStatusDetailTableViewCell") as! RepairOrderStatusDetailTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        print(dic)
        cell.lblRepairOrderStatus.text = dic.value(forKey: "STATUS_DESC") as? String
        cell.lblRemarks.text = dic.value(forKey: "JRD_REMARKS") as? String
        let dobStr = dic.value(forKey: "JRD_CR_DT") as? String
        cell.lblRepairOrderCreatedBy.text = dic.value(forKey: "JRD_CR_UID") as? String
        if dobStr != nil {
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            cell.lblRepairOrderDate.text =  dateFormatter.string(from: date!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        showErrorMsg("Remarks", message: dic.value(forKey: "JRD_REMARKS") as! String)
        //print(dic.value(forKey: "JWD_REMARKS"))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.0
    }
    
    @IBAction func btnStatusTouchUpInside(_ sender: Any) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS) as! NSMutableDictionary
            performSegue(withIdentifier: "ToRepairOrderStatus", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    
    @IBAction func txtStatusTouchDown(_ sender: Any) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS) as! NSMutableDictionary
            performSegue(withIdentifier: "ToRepairOrderStatus", sender: self)
        } else {
            //present a alret view.
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
    
    @IBAction func btnUpdateStatus(_ sender: Any) {
        if txtStatusCode.text == "" {
            showErrorMsg("Mandatory Field", message: "Status Code is not entered!")
            return
        }
        let adminDic = adminModel.userDataDic
        
        let roStatusCheck = NSMutableDictionary()
        roStatusCheck.setValue(roInfo.value(forKey: Constants.JRH_NO), forKey: "repairOrderNo")
        roStatusCheck.setValue(roInfo.value(forKey: Constants.JRD_STATUS_CODE), forKey: "repairOrderCurrentStatus")
        roStatusCheck.setValue(txtStatusCode.text, forKey: "repairOrderProposedStatus")
        roStatusCheck.setValue(roInfo.value(forKey: Constants.JRH_LOCN_CODE), forKey: "repairOrderLocation")
        roStatusCheck.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: "LOCN_CODE")
        let roModel = RepairOrderModel()
        let controller = RepairOrderController()
        roModel.requestType.setObject(roStatusCheck, forKey: Constants.FIND_REPAIR_ORDER_STATUS_CHECK as NSCopying)
        let resModel = controller.performSyncRequest(roModel) as! RepairOrderModel
        
        let tempRes = resModel.responseResult.value(forKey: Constants.FIND_REPAIR_ORDER_STATUS_CHECK) as! NSMutableDictionary
        if let statuscheckval = tempRes.value(forKey: "Status") {
            if statuscheckval as! String == "success" {
                
            }else{
                let msgval = tempRes.value(forKey: "Message")  as! String
                showErrorMsg(msgval, message: "")
                return
            }
        }
        
        
        let roInfos = NSMutableDictionary()
        roInfos.setValue(roInfo.value(forKey: Constants.JRH_NO), forKey: Constants.JRH_NO)
        roInfos.setValue(roInfo.value(forKey: Constants.JRH_SYS_ID), forKey: Constants.JRD_JWH_SYS_ID)
        roInfos.setValue(txtStatusCode.text, forKey: Constants.JRD_STATUS_CODE)
        roInfos.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JRD_CR_UID)
        roInfos.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JRD_UPD_UID)
        roInfos.setValue(txtViewRemarks.text, forKey: Constants.JRD_REMARKS)
        roInfos.setValue("Update", forKey: "RTYPE")
        if updateRepairOrderStatuses(roInfos) {
            showErrorMsg("Success", message: "RepairOrder Status Updated Successfully!")
        }else {
            showErrorMsg("Error Occured", message: "Unable to update Status")
        }

    }
    
    func updateRepairOrderStatuses(_ roInfos : NSMutableDictionary) -> Bool{
        var success = true
        searchkeyResult.removeAll()
        searchResult.removeAllObjects()
        
        let roModel = RepairOrderModel()
        let controller = RepairOrderController()
        roModel.requestType.setObject(roInfos, forKey: Constants.FIND_REPAIR_ORDER_STATUSES as NSCopying)
        let resModel = controller.performSyncRequest(roModel) as! RepairOrderModel
        let tempResulDic = resModel.responseResult.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) as! NSMutableDictionary
        let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        if errorMsg == nil  {
            searchResult = resModel.responseResult.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) as! NSMutableDictionary
            searchkeyResult = searchResult.allKeys as! [String]
        } else if errorMsg == Constants.SEARCH_NO_RESULT {
            let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Repair Orders available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            searchkeyResult.removeAll()
            searchResult.removeAllObjects()
            success = false
        } else {
            //Show alert view
        }
        self.tableview.reloadData()
        return success
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToRepairOrderAddEdit" {
            let destinationVC = segue.destination as! AddEditRepairOrder
            destinationVC.roInfo = roInfo
            destinationVC.parentViewer = self
            destinationVC.operationType = Constants.OPERATION_TYPE_VIEW
            
            destinationVC.barButtonSave.isEnabled = false
        }else if segue.identifier == "ToRepairOrderStatus" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_DETAILS
        }else if segue.identifier == "ToRepairOrderSummary" {
            let destVc = segue.destination as? RepairOrderSummary
            if let result_number = roInfo.value(forKey: Constants.JRH_NO) as? NSNumber
            {
                destVc?.roId = "\(result_number)"
            }
            /*if let result = woInfo.value(forKey: "TPOSWOD_PATIENT_MOBILE")
             {
             if result == nil {
             
             }else{
             destVc?.mobile = result as! String
             }
             }*/
        }
    }
    
    func fillData() {
        if let val = roInfo?.value(forKey: Constants.JRH_REF_SYS_ID) {
            var temp = String(describing: val)
            lblSalesOrderNo.text = temp
        }
        if let val = roInfo?.value(forKey: Constants.TPOSROD_OPTIMETRIST) {
            lblCreatedBy.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_LOCN_CODE) {
            lblLocationCreated.text = val as? String
        }
        if let val = roInfo?.value(forKey: Constants.JRH_DT) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            lblWorkOrderDate.text = dateFormatter.string(from: date!)
        }
        if let val = roInfo?.value(forKey: Constants.TPOSROD_DELIVERY_DATE) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            lblDeliveryDate.text = dateFormatter.string(from: date!)
        }
    }

}
