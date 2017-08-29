//
//  CustomerHistoryView.swift
//  TouchymPOS
//
//  Created by user115796 on 3/11/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistoryView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    var customerHistoryData: NSMutableDictionary = NSMutableDictionary()
    var customerHistoryKey = [String]()
    var customerData: NSMutableDictionary = NSMutableDictionary()
    
    var selectedHistoryData : NSMutableDictionary!
    var selectedHistoryType : String!
    var selectedHistoryDataDetail : NSMutableDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = true
        customerHistoryKey = customerHistoryData.allKeys as! [String]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerHistoryKey.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomerHistoryTableViewCell
        let key = customerHistoryKey[indexPath.row]
        let dic = customerHistoryData.value(forKey: key) as! NSMutableDictionary
        cell.lblPvComCode.text = dic.value(forKey: Constants.PV_COMP_CODE) as? String
        
        var dobStr = dic.value(forKey: Constants.PV_DATE) as? String
        let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dobStr!.substring(with: range))
        dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.lblPvDate.text = dateFormatter.string(from: date!)
        cell.lblPvInvoiceNo.text = dic.value(forKey: Constants.PV_InvoiceNo) as? String
        cell.lblPVLocationCode.text = dic.value(forKey: Constants.PV_LOCN_CODE) as? String
        cell.lblPvSalseOrderNo.text = dic.value(forKey: Constants.PV_SalesOrderNo) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cuHistoryController = CustomerHistoryController()
        let cuHistoryModel = CustomerHistoryModel()
        let request = cuHistoryModel.reqeustType
        
        let key = customerHistoryKey[indexPath.row]
        selectedHistoryData = customerHistoryData.value(forKey: key) as! NSMutableDictionary
        if selectedHistoryData == nil {
            return
        }
        selectedHistoryType = selectedHistoryData.value(forKey: Constants.PV_InvoiceNo) as? String
        if selectedHistoryType == nil || selectedHistoryType == " " {
            selectedHistoryType = selectedHistoryData.value(forKey: Constants.PV_SalesOrderNo) as? String
            if selectedHistoryType != nil && selectedHistoryType != "" {
                request.setValue(Constants.SEARCH_REQUEST, forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER)
                request.setValue(selectedHistoryData, forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER)
                let res = cuHistoryController.performSyncRequest(cuHistoryModel) as! CustomerHistoryModel
                if res.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
                    selectedHistoryDataDetail = res.responseResult.value(forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER) as! NSMutableDictionary
                    performSegue(withIdentifier: "ToSalesOrder", sender: self)
                } else {
                    //SHow error message.
                }
                
            }
        } else {
            request.setValue(Constants.SEARCH_REQUEST, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
            request.setValue(selectedHistoryData, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
            let res =  cuHistoryController.performSyncRequest(cuHistoryModel) as! CustomerHistoryModel
            if res.responseResult.value(forKey: Constants.ERROR_RESPONSE) == nil {
                selectedHistoryDataDetail = res.responseResult.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) as! NSMutableDictionary
                performSegue(withIdentifier: "ToInvoice", sender: self)
            } else {
                //show error message
            }
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToSalesOrder" {
            let destiVc = segue.destination as? CustomerHistorySalesOrderView
            destiVc?.invoiceData = selectedHistoryDataDetail
            destiVc?.invoiceTableKey = selectedHistoryDataDetail.value(forKey: Constants.TRANS_ITEMS) as! [NSDictionary]
            destiVc?.historeyType = selectedHistoryType
        } else if segue.identifier == "ToInvoice" {
            let destiVc = segue.destination as? CustomerHistoryInvoiceView
            destiVc?.invoiceData = selectedHistoryDataDetail
            destiVc?.invoiceTableKey = selectedHistoryDataDetail.value(forKey: Constants.TRANS_ITEMS) as! [NSDictionary]
            destiVc?.historeyType = selectedHistoryType
            
            
        }
    }
}
