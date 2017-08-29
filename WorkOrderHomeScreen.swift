//
//  WorkOrderHomeScreen.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 10/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderHomeScreen: UIViewController, UITableViewDataSource, UISearchBarDelegate,UITableViewDelegate {

    var searchResult :NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive = false
    var data = [String]()
    var filtteredData = [String]()
    let workOrderController = WorkOrderController()
    var searchkeyResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.isScrollEnabled = true

    }
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchBar.text=""
        searchkeyResult.removeAll()
        searchResult.removeAllObjects()
        self.tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WorkOrderEdit" {
            if let destinationVC = segue.destination as? AddEditWorkOrder {
                let key = searchkeyResult[(self.tableview.indexPathForSelectedRow?.row)!]
                destinationVC.woInfo = searchResult.value(forKey: key) as? NSMutableDictionary
                    destinationVC.parentViewer = self
                    destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
                }
        } else if segue.identifier == "WorkOrderAdd" {
                if let destinationVC = segue.destination as? AddEditWorkOrder{
                    destinationVC.parentViewer = self
                    destinationVC.operationType = Constants.OPERATION_TYPE_ADD
                }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        if(self.searchBar.text != "") {
            let woModel: WorkOrderModel  = WorkOrderModel()
            woModel.requestType.setObject(self.searchBar.text!, forKey: Constants.CU_SEARCH_BY_PHONE_NO as NSCopying)
            let resModel = workOrderController.performSyncRequest(woModel) as! WorkOrderModel
            let tempResulDic = resModel.responseResult.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! NSMutableDictionary
            let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil  {
                searchResult = resModel.responseResult.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! NSMutableDictionary
                searchkeyResult = searchResult.allKeys as! [String]
            } else if errorMsg == Constants.SEARCH_NO_RESULT {
                let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Work Order available for this phone number.",preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                //Show alert view
            }
        }
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderHomeTableViewCell") as! WorkOrderHomeTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        print(dic)
        cell.lblCustomerName.text = dic.value(forKey: "TPOSWOD_PATIENT_NAME") as? String
        cell.lblCustomerNo.text = dic.value(forKey: "JWH_PATIENT_ID") as? String
        let jwhno = dic.value(forKey: "JWH_NO") as! NSInteger
        cell.lblWorkOrderNo.text = "\(jwhno)"
        let dobStr = dic.value(forKey: "JWH_CR_DT") as? String
        cell.lblStatus.text = dic.value(forKey: "JWD_STATUS_CODE") as? String
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
        return 100.0
    }
}
