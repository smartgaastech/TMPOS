//
//  RepairOrderStatus.swift
//  TouchymPOS
//
//  Created by ESHACK on 7/26/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderStatus: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    
    @IBOutlet weak var txtCreatedBy: UITextField!
    @IBOutlet weak var txtLocationCreated: UITextField!
    @IBOutlet weak var txtWOStatus: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    
    let adminModel = AdminSettingModel.getInstance()
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    var searchResultUpdater : NSMutableDictionary = NSMutableDictionary()
    
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var roInfo : NSMutableDictionary!
    var data = [String]()
    var filtteredData = [String]()
    let repairOrderController = RepairOrderController()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairOrderStatusTableViewCell") as! RepairOrderStatusTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        print(dic)
        cell.lblROLocation.text = dic.value(forKey: "JRH_LOCN_CODE") as? String
        cell.lblROCreatedBy.text = dic.value(forKey: "TPOSROD_OPTIMETRIST") as? String
        let jwhno = dic.value(forKey: "JRH_NO") as! NSInteger
        cell.lblRONumber.text = "\(jwhno)"
        let dobStr = dic.value(forKey: "JRH_CR_DT") as? String
        cell.lblROStatus.text = dic.value(forKey: "STATUS_DESC") as? String
        //cell.lblROStatus.text = dic.value(forKey: "JRD_STATUS_CODE") as? String
        if dobStr != nil {
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            cell.lblDate.text =  dateFormatter.string(from: date!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.0
    }

    @IBAction func txtFromDateTouchDown(_ sender: Any) {
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
    
    @IBAction func txtToDateTouchDown(_ sender: Any) {
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
    
    @IBAction func txtWOStatusTouchDown(_ sender: Any) {
        
    }
    
    @IBAction func txtLocationCreatedTouchDown(_ sender: Any) {
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
    
    @IBAction func txtCreatedByTouchDown(_ sender: Any) {
    }
    
    @IBAction func btnToDateTouchUpInside(_ sender: Any) {
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
    
    @IBAction func btnFromDateTouchUpInside(_ sender: Any) {
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
    
    @IBAction func btnWOStatusTouchUpInside(_ sender: Any) {
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
            performSegue(withIdentifier: "ToRepairStatus", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnLocationCreatedTouchUpInside(_ sender: Any) {
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
            performSegue(withIdentifier: "ToListViewForSalesMan", sender: self)
        } else {
            //present a alret view.
        }
    }
    
    @IBAction func btnFilterTouchUpInside(_ sender: Any) {
        if txtFromDate.text == "" {
            showErrorMsg("Mandatory Field", message: "'From Date' is not entered!")
            return
        }else if txtToDate.text == "" {
            showErrorMsg("Mandatory Field", message: "'To Date' is not entered!")
            return
        }
        let roModel = RepairOrderModel()
        let adminDic = adminModel.userDataDic
        roInfo = NSMutableDictionary()
        
        let controller = RepairOrderController()
        getValues(roInfo)
        roInfo.setValue(adminDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.RO_LOCN_ASSIGNED)
        roModel.requestType.setObject(roInfo, forKey: Constants.FILTER_REPAIR_ORDER_STATUS as NSCopying)
        let resModel = controller.performSyncRequest(roModel) as! RepairOrderModel
        let tempResulDic = resModel.responseResult.value(forKey: Constants.FILTER_REPAIR_ORDER_STATUS) as! NSMutableDictionary
        let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        if errorMsg == nil  {
            searchResult = resModel.responseResult.value(forKey: Constants.FILTER_REPAIR_ORDER_STATUS) as! NSMutableDictionary
            searchkeyResult = searchResult.allKeys as! [String]
        } else if errorMsg == Constants.SEARCH_NO_RESULT {
            let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Repair Orders available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            searchkeyResult.removeAll()
            searchResult.removeAllObjects()
        } else {
            //Show alert view
        }
        self.tableview.reloadData()

    }
    
    func getValues(_ roInfos : NSMutableDictionary) {
        if let val = txtFromDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            roInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.RO_FROM_DATE)
            //}
        }
        if let val = txtToDate.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //if !trimedSt.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.date(from: val)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            roInfos.setValue(dateFormatter.string(from: date!) , forKey: Constants.RO_TO_DATE)
            //}
        }
        if let val = txtLocationCreated.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.RO_LOCN_CREATED)
        }
        if let val = txtCreatedBy.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.RO_CREATED_USER)
        }
        if let val = txtWOStatus.text {
            let trimedSt = val.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            roInfos.setValue(val , forKey: Constants.RO_STATUS)
        }
        roInfos.setValue(adminModel.userDataDic.value(forKey: Constants.ADMIN_LOCATION_key), forKey: Constants.RO_LOCN_ASSIGNED)
    }

    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func btnWOTodaysEntryTouchUpInside(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        txtFromDate.text = result
        txtToDate.text = result
        txtLocationCreated.text = ""
        txtCreatedBy.text = ""
        txtWOStatus.text = ""
        //btnFilter.sendActions(for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_LOCATION_CODE) {
            txtLocationCreated.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        } else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_SALES_MAN) {
            txtCreatedBy.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        } else if let val = searchResultUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS) {
            txtWOStatus.text = (val as? NSMutableDictionary)?.value(forKey: Constants.COMP_CODE) as? String
        }
        searchResultUpdater = NSMutableDictionary()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLocationCreated" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_LOCATION_CODE
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_STATUS_HOME
        }else if segue.identifier == "ToListViewForSalesMan" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_SALES_MAN
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_STATUS_HOME
        } else if segue.identifier == "ToRepairStatus" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS
            destVc?.parentViewName = Constants.VIEWER_REPAIR_ORDER_STATUS_HOME
        } else if segue.identifier == "ToRepairOrderDetails" {
            let destinationVC = segue.destination as? RepairOrderDetails
            let key = searchkeyResult[(self.tableview.indexPathForSelectedRow?.row)!]
            destinationVC!.roInfo = searchResult.value(forKey: key) as? NSMutableDictionary
            destinationVC!.parentViewer = self
            
        }
    }
    
}
