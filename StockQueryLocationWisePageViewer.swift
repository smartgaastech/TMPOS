//
//  StockQueryLocationWise.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 8/6/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryLocationWisePageViewer: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataDic = NSMutableDictionary()
    var dataKey = [String]()
    var pageDic = NSDictionary()
    var adminModel : AdminSettingModel!
    
    @IBOutlet weak var dataTbl: UITableView!
    
    @IBOutlet weak var lblItemCode: UILabel!
    @IBOutlet weak var lblItemBarCode: UILabel!
    @IBOutlet weak var lblItemDesctiption: UILabel!
    @IBOutlet weak var lblItemLocation: UILabel!
    @IBOutlet weak var lblItemMainGroup: UILabel!
    @IBOutlet weak var lblItemSubGrup: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        adminModel = AdminSettingModel.getInstance()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        dataKey = dataDic.allKeys as! [String]
        dataTbl.delegate = self
        dataTbl.dataSource = self
        fillData()

    }
    
    func fillData() {
        lblItemCode.text = pageDic.value(forKey: Constants.ITEM_CODE) as? String
        lblItemBarCode.text = pageDic.value(forKey: Constants.ITEM_BAR_CODE) as? String
        lblItemDesctiption.text = pageDic.value(forKey: Constants.ITEM_DESC) as? String
        lblItemLocation.text = adminModel.userDataDic.value(forKey: Constants.LOCN_CODE) as? String
        lblItemMainGroup.text = pageDic.value(forKey: Constants.MAIN_GROUP) as? String
        lblItemSubGrup.text = pageDic.value(forKey: Constants.SUB_GROUP) as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataKey.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StockQueryLocationWiseTableCell
        let itemCode = dataKey[indexPath.row]
        let data = dataDic.value(forKey: itemCode) as! NSDictionary
        cell.locationCode.text = data.value(forKey: Constants.ITEM_LOCATION) as? String
        cell.stock.text = data.value(forKey: Constants.ITEM_STOCK) as? String
        cell.price1.text = data.value(forKey: Constants.ITEM_PRICE1) as? String
        cell.price2.text = data.value(forKey: Constants.ITEM_PRICE2) as? String
        cell.lblNo.text = String(indexPath.row + 1)
        return cell
    }
}
