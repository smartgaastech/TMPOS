//
//  CustomerHomeScreenViewer.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//
import Foundation
import UIKit
class CustomerHomeScreenViewer: UIViewController, UITableViewDataSource, UISearchBarDelegate,UITableViewDelegate {
    
   
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    var lblCustNo : UILabel!
    var btnLinkPatient : UIButton!
    var parentViewerName = ""
    var fromSONo = ""
    var searchActive = false
    var data = [String]()
    var filtteredData = [String]()
    let cuHomeScreenController = CustomerHomeScreenController()
    var searchType = ""
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var searchkeyResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = true
        searchType = Constants.CU_SEARCH_BY_PHONE_NO
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        self.tableView.reloadData()
    }
    
    @IBAction func butSearchTouchUpInside(_ sender: AnyObject) {
        searchType = Constants.CU_SEARCH_BY_PHONE_NO
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        if(self.searchBar.text != "") {
            searchType = Constants.CU_SEARCH_BY_PHONE_NO
            let cuModel: CustomerModel  = CustomerModel()
            cuModel.reqeustType.setObject(self.searchBar.text!, forKey: Constants.CU_SEARCH_BY_PHONE_NO as NSCopying)
            let resModel = cuHomeScreenController.performSyncRequest(cuModel) as! CustomerModel
            let errorMsg = resModel.responseResult.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil  {
                searchResult = resModel.responseResult
                searchkeyResult = searchResult.allKeys as! [String]
            } else if errorMsg == Constants.SEARCH_NO_RESULT {
                let alertController : UIAlertController = UIAlertController(title: "No Such PhonNumber", message: "No Such phone number available",preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                //Show alert view
            }
        } 
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.searchBar.text == ""){
            searchResult.removeAllObjects()
            searchkeyResult.removeAll()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnPatientAvatarTouchUpInside(_ sender: AnyObject) {
        if parentViewerName == "CustomerHistorySalesOrderView" && fromSONo != ""{
            //write code to update patient number in SalesOrder  with   - fromSONo
            let indexPath = IndexPath(row: sender.tag, section: 0)
            //let indexPath = self.tableView.indexPathForRowAtPoint(sender.center)!
            //let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomerHomeTableViewCell
            //let kk = cell.lblCuNo.text!
            let key = searchkeyResult[indexPath.row]
            let dic = searchResult.value(forKey: key) as! NSDictionary
           lblCustNo.text = dic.value(forKey: Constants.PM_CUST_NO) as? String
            btnLinkPatient.isHidden = true
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(searchType == Constants.CU_SEARCH_BY_PHONE_NO) {
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerHomeViewCell") as! CustomerHomeTableViewCell
        let key = searchkeyResult[indexPath.row]
        let dic = searchResult.value(forKey: key) as! NSDictionary
        cell.lblCuName.text = dic.value(forKey: Constants.PM_PATIENT_NAME) as? String
        cell.lblCuNo.text = dic.value(forKey: Constants.PM_CUST_NO) as? String
        cell.lblCuGender.text = dic.value(forKey: Constants.PM_GENDER) as? String
        let dobStr = dic.value(forKey: Constants.PM_DOB) as? String
        let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dobStr!.substring(with: range))
        dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.lblCuDob.text =  dateFormatter.string(from: date!) //dobStr!.substringWithRange(range) //dic.valueForKey(Constants.PM_DOB) as? String
        if parentViewerName == "CustomerHistorySalesOrderView" {
            cell.btnAvatar.setImage(UIImage(named: "UserCheck.png"), for: UIControlState())
            cell.btnAvatar.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if searchType == Constants.CU_SEARCH_BY_PHONE_NO {
            if segue.identifier == "ToCuDetailedInfoViewer" {
                if let destinationVC = segue.destination as? CustomerDetailedInfoViewer {
                    let key = searchkeyResult[(self.tableView.indexPathForSelectedRow?.row)!]
                    destinationVC.customerInfo = searchResult.value(forKey: key) as? NSMutableDictionary
                    destinationVC.parentViewer = self
                    destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
                }                
            } else if segue.identifier == "AddNewCustomer" {
                if let destinationVC = segue.destination as? AddEditCustomerViewer {
                    destinationVC.parentViewer = self
                    destinationVC.operationType = Constants.OPERATION_TYPE_ADD
                }
            }
        }
    }
}
