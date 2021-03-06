//
//  CustomerRxLense.swift
//  TouchymPOS
//
//  Created by user115796 on 3/12/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerRxContactLenseView: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var rxContactLenseData : NSMutableDictionary = NSMutableDictionary()
    var rxContactLenseKey = [String]()
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
        rxContactLenseKey = rxContactLenseData.allKeys as! [String]
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
        return rxContactLenseKey.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? RxContactLenseCells
        let key = rxContactLenseKey[indexPath.row]
        let data = rxContactLenseData.value(forKey: key)
        cell?.rxContactLenseData = data as! NSMutableDictionary
        cell?.fillData()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.00
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RxToDetailContactLenseView" {
            if let destinationVC = segue.destination as? RxContactLenseDetailView {
                let key = rxContactLenseKey[(self.tableView.indexPathForSelectedRow?.row)!]
                destinationVC.rxContactLenseInfo = (rxContactLenseData.value(forKey: key)  as? NSMutableDictionary)!
                destinationVC.customerInfo = self.customerInfo
                destinationVC.parentViewer = self
                destinationVC.operationType = Constants.OPERATION_TYPE_EDIT
                if parentViewName == Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER {
                    let view = parentView as? AddEditWorkOrder
                    view!.txtPrescriptionNumberField.text = key
                }
            }
        } else if segue.identifier == "AddNewRxContactLense" {
            if let destinationVC = segue.destination as? RxContactLenseDetailView {
                destinationVC.customerInfo = self.customerInfo
                destinationVC.parentViewer = self
                destinationVC.operationType = Constants.OPERATION_TYPE_ADD
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
