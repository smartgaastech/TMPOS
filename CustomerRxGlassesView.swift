//
//  CustomerRxGlassesViewViewController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerRxGlassesView : UIViewController,UITableViewDataSource, UITableViewDelegate {

    var rxGlassData : NSMutableDictionary = NSMutableDictionary()
    var rxGlassKey = [String]()
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblCuOptimestric: UILabel!
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblCuNo: UILabel!
    
    var parentView : UIViewController!
    var parentViewName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rxGlassKey = rxGlassData.allKeys as! [String]
        fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rxGlassKey.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? RxGlassesCell
        let key = rxGlassKey[indexPath.row]
        let data = rxGlassData.value(forKey: key)
        cell?.rxGlassesData = data as! NSMutableDictionary
        cell?.fillData()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.00
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToRxGlassesDetailedView" {
            if let destinationVC = segue.destination as? RXGlassesDetailedView {
                let key = rxGlassKey[(self.tableView.indexPathForSelectedRow?.row)!]
                destinationVC.rxGlassData = (rxGlassData.value(forKey: key)  as? NSMutableDictionary)!
                destinationVC.customerInfo = self.customerInfo
                destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
                destinationVC.parentViewer = self
                if parentViewName == Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER {
                    let view = parentView as? AddEditWorkOrder
                    view!.txtPrescriptionNumberField.text = key
                }
            }
        } else if segue.identifier == "AddNewRxGlasses" {
            if let destinationVC = segue.destination as? RXGlassesDetailedView {
                destinationVC.customerInfo = self.customerInfo
                destinationVC.operationType = Constants.OPERATION_TYPE_ADD
                destinationVC.parentViewer = self
            }
        }
    }
    
    func fillData() {
        if let val = customerInfo.value(forKey: Constants.PM_PATIENT_NAME) {
            lblCuName.text = val as? String
        }
        if let val = customerInfo.value(forKey: Constants.PM_CUST_NO) {
            lblCuNo.text = val as? String
        }
        if let val = customerInfo.value(forKey: Constants.PM_SM_CODE) {
            lblCuOptimestric.text = val as? String
        }
    }
}
