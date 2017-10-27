//
//  WorkOrderDetails.swift
//  TouchymPOS
//
//  Created by ESHACK on 11/29/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit


class WorkOrderDetails: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    var woInfo : NSMutableDictionary!
    var parentViewer : UIViewController!
    
    @IBOutlet weak var lblWorkOrderDate: UILabel!
    @IBOutlet weak var lblPrescriptionType: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblLocationCreated: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtViewRemarks: UITextView!
    @IBOutlet weak var txtStatusCode: UITextField!
    
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    let adminModel = AdminSettingModel.getInstance()
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var searchkeyResult = [String]()
    
    @IBAction func btnSummaryTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "ToWorkOrderSummary", sender: self)
        //performSegue(withIdentifier: "ToWorkOrderStatus", sender: self)

    }
    
    
    
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
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS) {
            txtStatusCode.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
            tempbool = false
        }else {
            fillData()
            let woInfos = NSMutableDictionary()
            woInfos.setValue(woInfo.value(forKey: Constants.JWH_NO), forKey: Constants.JWH_NO)
            updateWorkOrderStatuses(woInfos)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderStatusDetailTableViewCell") as! WorkOrderStatusDetailTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        print(dic)
        cell.lblWorkOrderStatus.text = dic.value(forKey: "STATUS_DESC") as? String
        cell.lblRemarks.text = dic.value(forKey: "JWD_REMARKS") as? String
        let dobStr = dic.value(forKey: "JWD_CR_DT") as? String
        cell.lblWorkOrderCreatedBy.text = dic.value(forKey: "JWD_CR_UID") as? String
        if dobStr != nil {
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            cell.lblWorkOrderDate.text =  dateFormatter.string(from: date!)
        }
        //cell.tag = indexPath.row
        //cell.target(forAction: "getAction:", withSender: self)
        return cell
    }
    
    /*func getAction(sender:UITableViewCell)->Void {
        if(sender.tag == 0) {
            print("it worked")
            let cell =  sender as! WorkOrderStatusDetailTableViewCell
            print(cell.lblRemarks.text)
        }
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        showErrorMsg("Remarks", message: dic.value(forKey: "JWD_REMARKS") as! String)
        //print(dic.value(forKey: "JWD_REMARKS"))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.0
    }
    
    
    
    @IBAction func btnUpdateStatus(_ sender: AnyObject) {
        if txtStatusCode.text == "" {
            showErrorMsg("Mandatory Field", message: "Status Code is not entered!")
            return
        }
        let adminDic = adminModel.userDataDic
        
        let woStatusCheck = NSMutableDictionary()
        woStatusCheck.setValue(woInfo.value(forKey: Constants.JWH_NO), forKey: "workOrderNo")
        woStatusCheck.setValue(woInfo.value(forKey: Constants.JWD_STATUS_CODE), forKey: "workOrderCurrentStatus")
        woStatusCheck.setValue(txtStatusCode.text, forKey: "workOrderProposedStatus")
        woStatusCheck.setValue(woInfo.value(forKey: Constants.JWH_LOCN_CODE), forKey: "workOrderLocation")
        woStatusCheck.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: "LOCN_CODE")
        let woModel = WorkOrderModel()
        let controller = WorkOrderController()
        woModel.requestType.setObject(woStatusCheck, forKey: Constants.FIND_WORK_ORDER_STATUS_CHECK as NSCopying)
        let resModel = controller.performSyncRequest(woModel) as! WorkOrderModel
        
            let tempRes = resModel.responseResult.value(forKey: Constants.FIND_WORK_ORDER_STATUS_CHECK) as! NSMutableDictionary
            if let statuscheckval = tempRes.value(forKey: "Status") {
                if statuscheckval as! String == "success" {
                    
                }else{
                    let msgval = tempRes.value(forKey: "Message")  as! String
                    showErrorMsg(msgval, message: "")
                    return
                }
            }
        
        
        let woInfos = NSMutableDictionary()
        woInfos.setValue(woInfo.value(forKey: Constants.JWH_NO), forKey: Constants.JWH_NO)
        woInfos.setValue(woInfo.value(forKey: Constants.JWH_SYS_ID), forKey: Constants.JWD_JWH_SYS_ID)
        woInfos.setValue(txtStatusCode.text, forKey: Constants.JWD_STATUS_CODE)
        woInfos.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JWD_CR_UID)
        woInfos.setValue(adminDic.value(forKey: Constants.LOGGED_USER_NAME), forKey: Constants.JWD_UPD_UID)
        woInfos.setValue(txtViewRemarks.text, forKey: Constants.JWD_REMARKS)
        woInfos.setValue("Update", forKey: "RTYPE")
        if updateWorkOrderStatuses(woInfos) {
            showErrorMsg("Success", message: "WorkOrder Status Updated Successfully!")
        }else {
            showErrorMsg("Error Occured", message: "Unable to update Status")
        }
    }
    
    func updateWorkOrderStatuses(_ woInfos : NSMutableDictionary) -> Bool{
        var success = true
        searchkeyResult.removeAll()
        searchResult.removeAllObjects()
        
        let woModel = WorkOrderModel()
        let controller = WorkOrderController()
        woModel.requestType.setObject(woInfos, forKey: Constants.FIND_WORK_ORDER_STATUSES as NSCopying)
        let resModel = controller.performSyncRequest(woModel) as! WorkOrderModel
        let tempResulDic = resModel.responseResult.value(forKey: Constants.FIND_WORK_ORDER_STATUSES) as! NSMutableDictionary
        let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        if errorMsg == nil  {
            searchResult = resModel.responseResult.value(forKey: Constants.FIND_WORK_ORDER_STATUSES) as! NSMutableDictionary
            searchkeyResult = searchResult.allKeys as! [String]
        } else if errorMsg == Constants.SEARCH_NO_RESULT {
            let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Work Orders available.",preferredStyle: UIAlertControllerStyle.alert)
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
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func txtStatusCode(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS) as! NSMutableDictionary
            performSegue(withIdentifier: "ToWorkOrderStatus", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnStatus(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        reqDic.setValue(searchReq, forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS) as! NSMutableDictionary
            performSegue(withIdentifier: "ToWorkOrderStatus", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWorkOrderAddEdit" {
            let destinationVC = segue.destination as! AddEditWorkOrder
            destinationVC.woInfo = woInfo
            destinationVC.parentViewer = self
            destinationVC.operationType = Constants.OPERATION_TYPE_VIEW
            destinationVC.barButtonSave.isEnabled = false
        }else if segue.identifier == "ToWorkOrderStatus" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_DETAILS
        }else if segue.identifier == "ToWorkOrderSummary" {
            let destVc = segue.destination as? WorkOrderSummary
            if let result_number = woInfo.value(forKey: Constants.JWH_NO) as? NSNumber
            {
                destVc?.woId = "\(result_number)"
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
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_PRES_TYPE) {
            lblPrescriptionType.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_OPTIMETRIST) {
            lblCreatedBy.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.JWH_LOCN_CODE) {
            lblLocationCreated.text = val as? String
        }
        if let val = woInfo?.value(forKey: Constants.JWH_DT) {
            let dobStr = val as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            lblWorkOrderDate.text = dateFormatter.string(from: date!)
        }
        if let val = woInfo?.value(forKey: Constants.TPOSWOD_DELIVERY_DATE) {
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
