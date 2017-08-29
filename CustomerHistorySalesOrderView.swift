//
//  CustomerHistorySalesOrderView.swift
//  TouchymPOS
//
//  Created by XCodeClub on 2016-05-01.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistorySalesOrderView: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var parentViewName = ""
    @IBOutlet weak var tableView: UITableView!
    var invoiceData : NSMutableDictionary = NSMutableDictionary()
    var invoiceTableKey = [NSDictionary]()
    var historeyType : String!
    
    @IBOutlet weak var btnLinkPatient: UIButton!
    @IBOutlet weak var lblTransNo: UILabel!
    @IBOutlet weak var lblTransDate: UILabel!
    @IBOutlet weak var lblTransSalesMan: UILabel!
    @IBOutlet weak var lblTransLocation: UILabel!
    @IBOutlet weak var lblGrassTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = true
        fillData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWorkOrderAddEdit" {
            let destVc = segue.destination as? AddEditWorkOrder
            destVc?.soNo = invoiceData.value(forKey: Constants.TRANS_NO) as! String
            destVc?.operationType = Constants.OPERATION_TYPE_ADD
        }else if segue.identifier == "ToCustomerHomeScreen" {
            let destVc = segue.destination as? CustomerHomeScreenViewer
            destVc?.parentViewerName = "CustomerHistorySalesOrderView"
            destVc?.lblCustNo = lblCustomerNo
            destVc?.btnLinkPatient = btnLinkPatient
            destVc?.fromSONo = lblTransNo.text!
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
    
    @IBAction func AddWorkOrderForSalesOrder(_ sender: AnyObject) {
        //Need to write check from where the request parent is from
        if parentViewName == "AddEditWorkOrder" {
             showErrorMsg("Already came from WorkOrder to select SalesOrder!", message: "Please go back to WorkOrder Add/Edit...")
        }else {
            performSegue(withIdentifier: "ToWorkOrderAddEdit", sender: self)
        }
    }
    
    
    @IBAction func btnLinkPatientTouchUpInside(_ sender: AnyObject) {
        let custno = lblCustomerNo.text
        if custno == "" {
            performSegue(withIdentifier: "ToCustomerHomeScreen", sender: self)
        }
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
        let custNo = invoiceData.value(forKey: Constants.TRANS_PATIENT_NO) as! String
        if custNo != "0" {
            lblCustomerNo.text = custNo
            btnLinkPatient.isHidden = true
        }
        if let val = invoiceData.value(forKey: Constants.TRANS_PATIENT_NAME) {
            lblCustomerName.text = val as? String
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomerHistorySalesOrderTableCell
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
