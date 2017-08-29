//
//  CustomerSlitAndKReadings.swift
//  TouchymPOS
//
//  Created by user115796 on 3/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerSlitAndKReadingsView: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    var slitKReadingData : NSMutableDictionary = NSMutableDictionary()
    var slitKReadingKey = [String]()
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    
    
    @IBOutlet weak var tableView: UITableView!
    var parentView : UIViewController!
    var parentViewName = ""
    @IBOutlet weak var lblCuOptimestric: UILabel!
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblCuNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        slitKReadingKey = slitKReadingData.allKeys as! [String]
        fillData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slitKReadingKey.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SlitKReadingCell
        let key = slitKReadingKey[indexPath.row]
        let data = slitKReadingData.value(forKey: key)
        cell?.slitKReadingData = data as! NSMutableDictionary
        cell?.fillData()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.00
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSlitKReadigDetailedView" {
            if let destinationVC = segue.destination as? SlitAndKReadingDetailedView {
                let key = slitKReadingKey[(self.tableView.indexPathForSelectedRow?.row)!]
                destinationVC.slitKReadingData = (slitKReadingData.value(forKey: key)  as? NSMutableDictionary)!
                destinationVC.customerInfo = self.customerInfo
                destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
                destinationVC.parentViewer = self
                if parentViewName == Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER {
                    let view = parentView as? AddEditWorkOrder
                    view!.txtPrescriptionNumberField.text = key
                }
            }
        }
        else if segue.identifier == "AddNewSlitKReadings" {
            if let destinationVC = segue.destination as? SlitAndKReadingDetailedView {
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

