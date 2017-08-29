//
//  CustomerHistoryInvoiceView.swift
//  TouchymPOS
//
//  Created by user115796 on 4/12/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistoryInvoiceView: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var invoiceData : NSMutableDictionary = NSMutableDictionary()
    var invoiceTableKey = [NSDictionary]()
    var historeyType : String!
    var parentViewName = ""
    var parentView : UIViewController!
    
    @IBOutlet weak var lblTransNo: UILabel!
    @IBOutlet weak var lblTransDate: UILabel!
    @IBOutlet weak var lblTransSalesMan: UILabel!
    @IBOutlet weak var lblTransLocation: UILabel!
    @IBOutlet weak var lblGrassTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = true
        //invoiceTableKey = invoiceTableData.allKeys as! [String]
        fillData()
        
    }
    
    func fillData() {
        if let val = invoiceData.value(forKey: Constants.TRANS_NO) {
            lblTransNo.text = val as? String
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_DATE) {
            let dobStr = invoiceData.value(forKey: Constants.TRANS_DATE) as? String
            let range = dobStr!.characters.index(dobStr!.startIndex, offsetBy: 0)..<dobStr!.characters.index(dobStr!.startIndex, offsetBy: 10)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dobStr!.substring(with: range))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            lblTransDate.text = dateFormatter.string(from: date!)
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_SALESMAN) {
            lblTransSalesMan.text = val as? String
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_GROSS_TOTAL) {
            lblGrassTotal.text = val as? String
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_LOCN) {
            lblTransLocation.text = val as? String
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_SUB_TOTAL) {
            lblSubTotal.text = val as? String
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_DISC) {
            lblDescription.text = val as? String
            
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_EXP) {
            lblExp.text = val as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceTableKey.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomerHistoryInvoiceTableCell
        let key = invoiceTableKey[indexPath.row]
        let dic = key 
        
        if let val = dic.value(forKey: Constants.ITEM_CODE)  {
            cell.lblIteamCode.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_NAME) {
            cell.lblIteamName.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_UOM) {
            cell.lblIteamUom.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_RATE) {
            cell.lblIteamRate.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_QTY) {
            cell.lblIteamQty.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_DISCOUNT) {
            cell.lblIteamDiscount.text = val as? String
        }
        if let val = dic.value(forKey: Constants.ITEM_AMT) {
            cell.lblIteamAmount.text = val as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
