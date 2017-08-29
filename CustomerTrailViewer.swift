//
//  CustomerTraiiewer.swift
//  TouchymPOS
//
//  Created by user115796 on 3/17/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerTrailViewer: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var trailData : NSMutableDictionary = NSMutableDictionary()
    var trailKey = [String]()
    var customerInfo : NSMutableDictionary = NSMutableDictionary()
    var parentView : UIViewController!
    var parentViewName = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblCuOptimestric: UILabel!
    @IBOutlet weak var lblCuName: UILabel!
    @IBOutlet weak var lblCuNo: UILabel!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    trailKey = trailData.allKeys as! [String]
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
    return trailKey.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TrailDetailCell
    let key = trailKey[indexPath.row]
    let data = trailData.value(forKey: key)
    cell?.trailData = data as! NSMutableDictionary
    cell?.fillData()
    return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.00
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ToTrailDetailedView" {
        if let destinationVC = segue.destination as? TrailDetailedView {
            let key = trailKey[(self.tableView.indexPathForSelectedRow?.row)!]
            destinationVC.trailData = (trailData.value(forKey: key)  as? NSMutableDictionary)!
            destinationVC.customerInfo = self.customerInfo
            destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
            destinationVC.parentViewer = self
            if parentViewName == Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER {
                let view = parentView as? AddEditWorkOrder
                view!.txtPrescriptionNumberField.text = key
            }
        }
    }
    else if segue.identifier == "AddNewTrailDetail" {
        if let destinationVC = segue.destination as? TrailDetailedView {
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
