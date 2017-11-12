//
//  WorkOrderStatus.swift
//  TouchymPOS
//
//  Created by ESHACK on 11/1/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderStatus: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var btnFromDate: UIButton!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var btnToDate: UIButton!
    @IBOutlet weak var txtLocationCreated: UITextField!
    @IBOutlet weak var btnLocationCreated: UIButton!
    @IBOutlet weak var txtCreatedBy: UITextField!
    @IBOutlet weak var btnCreatedBy: UIButton!
    @IBOutlet weak var btnWOStatus: UIButton!
    
    @IBOutlet weak var btnPrescriptionType: UIButton!
    @IBOutlet weak var txtPrescriptionType: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtWOStatus: UITextField!
    
    let adminModel = AdminSettingModel.getInstance()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var btnFilter: UIButton!
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var woInfo : NSMutableDictionary!
    var data = [String]()
    var filtteredData = [String]()
    let workOrderController = WorkOrderController()
    var searchkeyResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.isScrollEnabled = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        txtFromDate.text = result
        txtToDate.text = result
    }
    
    @IBAction func btnWOTodayEntryTouchUpInside(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        txtFromDate.text = result
        txtToDate.text = result
        txtLocationCreated.text = ""
        txtCreatedBy.text = ""
        txtWOStatus.text = ""
        btnFilter.sendActions(for: .touchUpInside)
    }
    
    @IBAction func btnClearTouchUpInside(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        txtFromDate.text = result
        txtToDate.text = result
        txtLocationCreated.text = ""
        txtCreatedBy.text = ""
        txtWOStatus.text = ""
        searchkeyResult.removeAll()
        searchResult.removeAllObjects()
        self.tableview.reloadData()
    }
    
    func getValues(_ woInfos : NSMutableDictionary) {
        if let val = txtFromDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            woInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.WO_FROM_DATE)
            //}
        }
        if let val = txtToDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            woInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.WO_TO_DATE)
            //}
        }
        if let val = txtLocationCreated.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.WO_LOCN_CREATED)
        }
        if let val = txtCreatedBy.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.WO_CREATED_USER)
        }
        if let val = txtWOStatus.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.WO_STATUS)
        }
        if let val = txtPrescriptionType.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            woInfos.setValue(val , forKey: Constants.WO_PRESCRIPTION_TYPE)
        }
        woInfos.setValue(adminModel.userDataDic.value(forKey: Constants.ADMIN_LOCATION_key), forKey: Constants.WO_LOCN_ASSIGNED)
    }
    
    @IBAction func bntFilterTouchUpInside(_ sender: AnyObject) {
        if txtFromDate.text == "" {
            showErrorMsg("Mandatory Field", message: "'From Date' is not entered!")
            return
        }else if txtToDate.text == "" {
            showErrorMsg("Mandatory Field", message: "'To Date' is not entered!")
            return
        }
        let woModel = WorkOrderModel()
        let adminDic = adminModel.userDataDic
        woInfo = NSMutableDictionary()
        
        let controller = WorkOrderController()
        getValues(woInfo)
        woInfo.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.WO_LOCN_ASSIGNED)
        print(woInfo)
        woModel.requestType.setObject(woInfo, forKey: Constants.FILTER_WORK_ORDER_STATUS as NSCopying)
        let resModel = controller.performSyncRequest(woModel) as! WorkOrderModel
        let tempResulDic = resModel.responseResult.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) as! NSMutableDictionary
        let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        if errorMsg == nil  {
            searchResult = resModel.responseResult.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) as! NSMutableDictionary
            let sortedKeys = (searchResult.allKeys as! [String]).sorted(by: <) as Array
            searchkeyResult = sortedKeys
            //searchkeyResult = searchResult.allKeys as! [String]
        } else if errorMsg == Constants.SEARCH_NO_RESULT {
            let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Work Orders available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            searchkeyResult.removeAll()
            searchResult.removeAllObjects()
        } else {
            //Show alert view
        }
        self.tableview.reloadData()
    }
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderStatusTableViewCell") as! WorkOrderStatusTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        
        cell.lblWorkOrderLocation.text = dic.value(forKey: "JWH_LOCN_CODE") as? String
        cell.lblWorkOrderCreated.text = dic.value(forKey: "TPOSWOD_OPTIMETRIST") as? String
        let jwhno = dic.value(forKey: "JWH_NO") as! NSInteger
        cell.lblWorkOrderNo.text = "\(jwhno)"
        let dobStr = dic.value(forKey: "JWH_CR_DT") as? String
        cell.lblWorkOrderStatus.text = dic.value(forKey: "TPOSWOD_STATUS_CODE_DESC") as? String
        if dobStr != nil {
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            cell.lblWorkOrderDate.text =  dateFormatter.string(from: date!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) {
            txtLocationCreated.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        } else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            txtCreatedBy.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        } else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS) {
            txtWOStatus.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
        searchResultUpdater = NSMutableDictionary()
    }
    
    @IBAction func btnWOStatusTouchUpInside(_ sender: AnyObject) {
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
    
    @IBAction func txtWOStatusTouchUpInside(_ sender: AnyObject) {
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
            performSegue(withIdentifier: "ToListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnPrescriptionTypeTouchUpInside(_ sender: Any) {
        let popoverContent = PrescriptionTypeController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.txtPrescriptionType = txtPrescriptionType
        popoverContent.fromWorkOrderStatusPage = true
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 150, height: 110)
        popover!.sourceView = txtPrescriptionType
        popover!.sourceRect = txtPrescriptionType.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
        txtPrescriptionType.text = ""
    }
    
    @IBAction func txtPrescriptionTypeTouchDown(_ sender: Any) {
        
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
            performSegue(withIdentifier: "ToListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnLocationCreatedTouchUpInside(_ sender: AnyObject) {
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
            performSegue(withIdentifier: "ToLocationCreated", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLocationCreated" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_LOCATION_CODE
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_STATUS_HOME
        }else if segue.identifier == "ToListViewForSalesMan" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_STATUS_HOME
        } else if segue.identifier == "ToWorkOrderStatus" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS
            destVc?.parentViewName = Constants.VIEWER_WORK_ORDER_STATUS_HOME
        } else if segue.identifier == "ToWorkOrderDetails" {
            let destinationVC = segue.destination as? WorkOrderDetails
            let key = searchkeyResult[(self.tableview.indexPathForSelectedRow?.row)!]
            destinationVC!.woInfo = searchResult.value(forKey: key) as? NSMutableDictionary
            destinationVC!.parentViewer = self
        
        }
    }

    @IBAction func txtLocationCreatedTouchDown(_ sender: AnyObject) {
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
            performSegue(withIdentifier: "ToLocationCreated", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnToDateTouchUpInside(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtToDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 220)
        popover!.sourceView = txtToDate
        popover!.sourceRect = txtToDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func txtToDateTouchDown(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtToDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 220)
        popover!.sourceView = txtToDate
        popover!.sourceRect = txtToDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func txtFromDateTouchDown(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtFromDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 220)
        popover!.sourceView = txtFromDate
        popover!.sourceRect = txtFromDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func txtFromDateTouchUpInside(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnFromDateTouchUpInside(_ sender: AnyObject) {
        let popoverContent = DateViewController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtFromDate
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400, height: 220)
        popover!.sourceView = txtFromDate
        popover!.sourceRect = txtFromDate.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
    
}
