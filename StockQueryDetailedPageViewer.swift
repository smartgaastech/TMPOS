//
//  StockQueryDetailedPageViewer.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 5/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryDetailedPageViewer: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var dataDic = NSMutableDictionary()
    var dataKey = [String]()
    var pageDic = NSMutableDictionary()
    
    var searchResultDic : NSMutableDictionary!
    var nextPageDic = NSMutableDictionary()
    
    var adminModel : AdminSettingModel!
    
    @IBOutlet weak var dataTbl: UITableView!
    @IBOutlet var lblMainGroup: UILabel!
    @IBOutlet var lblSubGroup: UILabel!
    @IBOutlet var lblLocationCode: UILabel!
    @IBOutlet var lblFromItem: UILabel!
    @IBOutlet var lblToIteam: UILabel!
    @IBOutlet var lblPlCode: UILabel!
    
    var selectedStr : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataKey = dataDic.allKeys as! [String]
        adminModel = AdminSettingModel.getInstance()
        dataTbl.delegate = self
        dataTbl.dataSource = self
        fillData()
    }
    
    func fillData() {
        lblMainGroup.text = pageDic.value(forKey: Constants.MAIN_GROUP) as? String
        lblSubGroup.text = pageDic.value(forKey: Constants.SUB_GROUP) as? String
        lblLocationCode.text = pageDic.value(forKey: Constants.LOCN_CODE) as? String
        lblFromItem.text = pageDic.value(forKey: Constants.FROM_ITEM) as? String
        lblToIteam.text = pageDic.value(forKey: Constants.TO_ITEM) as? String
        lblPlCode.text = pageDic.value(forKey: Constants.PL_CODE) as? String
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataKey.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StockQueryDetailedCellTableViewCell
        let itemCode = dataKey[indexPath.row]
        let data = dataDic.value(forKey: itemCode) as! NSDictionary
        cell.lblBarCode.text = data.value(forKey: Constants.STOCK_ITEM_BAR_CODE) as? String
        cell.lblCode.text = data.value(forKey: Constants.STOCK_ITEM_CODE) as? String
        cell.lblDescription.text = data.value(forKey: Constants.STOCK_ITEM_DESC) as? String
        cell.lblGradeCode.text = data.value(forKey: Constants.STOCK_ITEM_GRADE_CODE) as? String
        cell.lblPrice1.text = data.value(forKey: Constants.STOCK_ITEM_PRICE1) as? String
        cell.lblPrice2.text = data.value(forKey: Constants.STOCK_ITEM_PRICE2) as? String
        cell.lblStock.text = data.value(forKey: Constants.STOCK_ITEM_STOCK) as? String
        cell.lblNo.text = String(indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stockQueryModel = StockQueryModel()
        let searchReq = NSMutableDictionary()
        let itemCode = dataKey[indexPath.row]
        let res = dataDic.value(forKey: itemCode) as! NSDictionary
        let keyEnum = res.keyEnumerator()
        nextPageDic.removeAllObjects()
        while let key = keyEnum.nextObject() {
            nextPageDic.setObject(res.value(forKey: key as! String)!, forKey: key as! String as NSCopying)
        }
        nextPageDic.setObject(lblMainGroup.text!, forKey: Constants.MAIN_GROUP as NSCopying)
        nextPageDic.setObject(lblSubGroup.text!, forKey: Constants.SUB_GROUP as NSCopying)
        
        let fromItem = nextPageDic.value(forKey: Constants.STOCK_ITEM_CODE) as? String
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(fromItem, forKey: Constants.FROM_ITEM)
        
        let controller = StockQueryController()
        stockQueryModel.reqeustType.setValue(searchReq, forKey: Constants.SEARCH_STOCK_QUERY_LOCATION_WISE_ITEM)
        let resModel = controller.performSyncRequest(stockQueryModel) as! StockQueryModel
        let stockQueryItem = resModel.responseResult.value(forKey: Constants.SEARCH_STOCK_QUERY_LOCATION_WISE_ITEM) as! NSMutableDictionary
        if (stockQueryItem.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = stockQueryItem
            performSegue(withIdentifier: "ToLocationWiseStockInfo", sender: nil)
        } else {
            let errorMsg = stockQueryItem.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLocationWiseStockInfo" {
            let destVc = segue.destination as? StockQueryLocationWisePageViewer
            destVc?.pageDic = nextPageDic
            destVc?.dataDic = searchResultDic
        }
    }
}
