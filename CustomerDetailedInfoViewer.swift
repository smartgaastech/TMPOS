//
//  CustomerDetailedInfoViewer.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewer: UITableViewController {
    
    var selectedIndexPath : IndexPath?
    var customerInfo : NSMutableDictionary?
    var canPerformSegue = true
    
    @IBOutlet weak var barSaveButton: UIBarButtonItem!
    var operationType: String = Constants.OPERATION_TYPE_EDIT
    let adminModel = AdminSettingModel.getInstance()
    
    /*ProtocolDelegateToView, That is table View implemented by Custom Cell and Customer Cell 
    contains value & Parent Table required the data hence using Custom Protocol Deletegate.
    */
    var responseProtocolDelegate : NSMutableDictionary = NSMutableDictionary()
    var listViewUpdater : NSMutableDictionary = NSMutableDictionary()
    var parentViewer : CustomerHomeScreenViewer!
    
    var generalCell : CustomerDetailedInfoViewGeneralCell!
    var addressCell : CustomerDetailedInfoViewAddressCell!
    var contactCell : CustomerDetailedInfoViewContactCell!
    var otherCell : CustomerDetailedInfoViewOtherCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        responseProtocolDelegate.removeAllObjects()
        listViewUpdater.removeAllObjects()        
        if customerInfo  == nil || customerInfo?.count == 0 {
            operationType = Constants.OPERATION_TYPE_ADD
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if customerInfo == nil || customerInfo?.count == 0 {
            return
        }
        if generalCell != nil {
            generalCell.customerInfo = self.customerInfo
            generalCell.fillData()
        }
        if addressCell != nil {
            addressCell.customerInfo = self.customerInfo
            addressCell.fillData()
        }
        if contactCell != nil {
            contactCell.customerInfo = self.customerInfo
            contactCell.fillData()
        }
        if otherCell != nil {
            otherCell.customerInfo = self.customerInfo!
            otherCell.fillData()
        }
    }

    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            generalCell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailedInfoViewGeneralCell") as! CustomerDetailedInfoViewGeneralCell
            generalCell.customerInfo = self.customerInfo
            generalCell?.fillData()
            generalCell?.txtCuCreatedByBox.addTarget(generalCell, action: "txtFieldTouchInside", for: UIControlEvents.touchUpInside)
            generalCell?.parent = self
            return generalCell!
        } else if indexPath.row == 1 {
            addressCell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailedInfoViewAddressCell") as! CustomerDetailedInfoViewAddressCell
            addressCell.customerInfo = self.customerInfo
            addressCell.fillData()
            return addressCell
        } else if indexPath.row == 2 {
            contactCell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailedInfoViewContactCell") as! CustomerDetailedInfoViewContactCell
            contactCell.customerInfo = self.customerInfo
            contactCell.fillData()
            return contactCell
        } else if indexPath.row == 3{
            otherCell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailedInfoViewOtherCell") as! CustomerDetailedInfoViewOtherCell
            otherCell.customerInfo = self.customerInfo!
            otherCell.fillData()
            return otherCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailedInfoViewVisitCell") as? CustomerDetailedInfoViewVisitCell
            cell?.customerInfo = self.customerInfo
            cell?.parentView = self
            return cell!
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == previousIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        var reloadIndexs : Array<IndexPath> = []
        if let previous = previousIndexPath {
            reloadIndexs.append(previous)
        }
        if let current = selectedIndexPath {
            reloadIndexs.append(current)
        }
        if reloadIndexs.count > 0 {
            tableView.reloadRows(at: reloadIndexs, with: UITableViewRowAnimation.automatic)
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            if indexPath.row == 0 {
                return CustomerDetailedInfoViewGeneralCell.expandedHeight
            } else if indexPath.row == 1 {
                return CustomerDetailedInfoViewAddressCell.expandedHeight
            } else if indexPath.row == 2 {
                return CustomerDetailedInfoViewContactCell.expandedHeight
            } else if indexPath.row == 3{
                return CustomerDetailedInfoViewOtherCell.expandedHeight
            }else {
                return CustomerDetailedInfoViewVisitCell.expandedHeight
            }
        } else {
            if indexPath.row == 0 {
                return CustomerDetailedInfoViewGeneralCell.expandedHeight
            } else if indexPath.row == 1 {
                return CustomerDetailedInfoViewAddressCell.defaultHeight
            } else if indexPath.row == 2 {
                return CustomerDetailedInfoViewContactCell.defaultHeight
            } else if indexPath.row == 3 {
                return CustomerDetailedInfoViewOtherCell.defaultHeight
            } else {
                return CustomerDetailedInfoViewVisitCell.defaultHeight
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerVisitToRxContactLense" {
            if let destinationVC = segue.destination as? CustomerRxContactLenseView {
                if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)  {
                    if (dataDic as AnyObject).value(forKey: Constants.ERROR_RESPONSE) == nil {
                        destinationVC.rxContactLenseData = dataDic as! NSMutableDictionary
                    }
                    destinationVC.customerInfo = self.customerInfo!
                }
            }
        } else if segue.identifier == "CustomerVisitToHistory" {
            if let destinationVC = segue.destination as? CustomerHistoryView {
                if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_HISTORY) {
                    destinationVC.customerHistoryData = dataDic as! NSMutableDictionary
                    destinationVC.customerData = self.customerInfo!
                }
            }
        } else if segue.identifier == "CustomerVisitToRxGlasses" {
            if let destinationVC = segue.destination as? CustomerRxGlassesView {
                if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_RX_GLASSES)  {
                    if (dataDic as AnyObject).value(forKey: Constants.ERROR_RESPONSE) == nil {
                        destinationVC.rxGlassData = dataDic as! NSMutableDictionary
                        
                    }
                    destinationVC.customerInfo = self.customerInfo!
                }
            }
        } else if segue.identifier == "CustomerVisitToSlitKReading" {
            if let destinationVC = segue.destination as? CustomerSlitAndKReadingsView {
                if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_SLIT_K_READING) {
                    if (dataDic as AnyObject).value(forKey: Constants.ERROR_RESPONSE) == nil {
                        destinationVC.slitKReadingData = dataDic as! NSMutableDictionary
                        
                    }
                    destinationVC.customerInfo = self.customerInfo!
                }
            }
        }
        else if segue.identifier == "CustomerVisitToTrail" {
            if let destinationVC = segue.destination as? CustomerTrailViewer {
                if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_TRAIL) {
                    if (dataDic as AnyObject).value(forKey: Constants.ERROR_RESPONSE) == nil {
                        destinationVC.trailData = dataDic as! NSMutableDictionary
                        
                    }
                    destinationVC.customerInfo = self.customerInfo!
                }
            }
        } else if segue.identifier == "FromCustomerDetailToCompanyCodeList" {
            if let destinationVC = segue.destination as? CompanyCodeListView {
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
                    destinationVC.dataDic = resDic
                    destinationVC.parentViewName = Constants.VIEWER_CUSTOMER_DETAILED_INFO_VIEWER
                }
            }
        } else if segue.identifier == "EditCustomer" {
            if let destinationVc = segue.destination as? AddEditCustomerViewer {
                destinationVc.customerInfo = self.customerInfo
                destinationVc.operationType = Constants.OPERATION_TYPE_EDIT
                destinationVc.parentViewer = self
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       
        if identifier == "CustomerVisitToHistory" {
            if let dataDic = responseProtocolDelegate.value(forKey: Constants.CU_SEARCH_BY_HISTORY) {
                if let errorMsg : String = (dataDic as AnyObject).value(forKey: Constants.ERROR_RESPONSE) as? String {
                    showErrorMsg("No Result", message: errorMsg)
                    return false
                }
            }
        }/* else if identifier == "CustomerVisitToRxContactLense" {
            if let dataDic = responseProtocolDelegate.valueForKey(Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)  {
                if let errorMsg : String = dataDic.valueForKey(Constants.ERROR_RESPONSE) as? String {
                    showErrorMsg("No result", message: errorMsg)
                    return false
                }
            }
        } else if identifier == "CustomerVisitToRxGlasses" {
            if let dataDic = responseProtocolDelegate.valueForKey(Constants.CU_SEARCH_BY_RX_GLASSES)  {
                if let errorMsg : String = dataDic.valueForKey(Constants.ERROR_RESPONSE) as? String {
                    showErrorMsg("No result", message: errorMsg)
                    return false
                }
            }
        } else if identifier == "CustomerVisitToSlitKReading" {
            if let dataDic = responseProtocolDelegate.valueForKey(Constants.CU_SEARCH_BY_SLIT_K_READING) {
                if let errorMsg : String = dataDic.valueForKey(Constants.ERROR_RESPONSE) as? String {
                    showErrorMsg("No Result", message: errorMsg)
                    return false
                }
            }
        } else if identifier == "CustomerVisitToTrail" {
            if let dataDic = responseProtocolDelegate.valueForKey(Constants.CU_SEARCH_BY_TRAIL)  {
                if let errorMsg : String = dataDic.valueForKey(Constants.ERROR_RESPONSE) as? String {
                    showErrorMsg("No result", message: errorMsg)
                    return false
                }
            }
        }*/
        
        return true
    }
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateEditedDataObject(_ cuInfo : NSMutableDictionary) {
        self.customerInfo = cuInfo
        let cuId = cuInfo.value(forKey: Constants.PM_CUST_NO) as! String
        if let _ = parentViewer.searchResult.value(forKey: cuId) as? NSMutableDictionary {
            parentViewer.searchResult.removeObject(forKey: cuId)
            parentViewer.searchResult.setValue(self.customerInfo, forKey: cuId)
            parentViewer.searchkeyResult = parentViewer.searchResult.allKeys as! [String]
        }
    }
    //Save Button Pressed.
    
}
