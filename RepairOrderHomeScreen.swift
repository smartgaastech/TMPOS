//
//  RepairOrderHomeScreen.swift
//  TouchymPOS
//
//  Created by ESHACK on 6/28/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderHomeScreen: UIViewController,  UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    
    var searchActive = false
    var data = [String]()
    var filtteredData = [String]()
    let repairOrderController = RepairOrderController()
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
        if segue.identifier == "RepairOrderEdit" {
            if let destinationVC = segue.destination as? AddEditRepairOrder {
                let key = searchkeyResult[(self.tableview.indexPathForSelectedRow?.row)!]
                destinationVC.roInfo = searchResult.value(forKey: key) as? NSMutableDictionary
                destinationVC.parentViewer = self
                destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
            }
        } else if segue.identifier == "RepairOrderAdd" {
            if let destinationVC = segue.destination as? AddEditRepairOrder{
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
            let roModel: RepairOrderModel  = RepairOrderModel()
            roModel.requestType.setObject(self.searchBar.text!, forKey: Constants.CU_SEARCH_BY_PHONE_NO as NSCopying)
            let resModel = repairOrderController.performSyncRequest(roModel) as! RepairOrderModel
            let tempResulDic = resModel.responseResult.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! NSMutableDictionary
            let errorMsg = tempResulDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil  {
                searchResult = resModel.responseResult.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! NSMutableDictionary
                searchkeyResult = searchResult.allKeys as! [String]
            } else if errorMsg == Constants.SEARCH_NO_RESULT {
                let alertController : UIAlertController = UIAlertController(title: "Sorry!!", message: "No Repair Order available for this phone number.",preferredStyle: UIAlertControllerStyle.alert)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairOrderHomeTableViewCell") as! RepairOrderHomeTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        print(dic)
        cell.lblCustomerName.text = dic.value(forKey: "TPOSROD_PATIENT_NAME") as? String
        cell.lblCustomerNo.text = dic.value(forKey: "JRH_PATIENT_ID") as? String
        let jwhno = dic.value(forKey: "JRH_NO") as! NSInteger
        cell.lblRepairOrderNo.text = "\(jwhno)"
        let dobStr = dic.value(forKey: "JRH_CR_DT") as? String
        cell.lblStatus.text = dic.value(forKey: "JRD_STATUS_CODE") as? String
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
