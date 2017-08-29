//
//  StockQueryController.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 6/4/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? StockQueryModel
        var responseModel = StockQueryModel()
        if(reqModel?.reqeustType.value(forKey: Constants.SEARCH_STOCK_QUERY_ITEM) != nil) {
            let postBody = reqModel?.reqeustType.value(forKey: Constants.SEARCH_STOCK_QUERY_ITEM) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Stock/ItemStockDetails/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            let res = performPostArrayRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                let keyEnum = res.keyEnumerator()
                while let key = keyEnum.nextObject() {
                    let dic = res.value(forKey: key as! String) as! NSDictionary
                    let code = dic.value(forKey: Constants.ITEM_CODE) as! String
                    responseDic.setObject(dic, forKey: code as NSCopying)
                }
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.SEARCH_STOCK_QUERY_ITEM)
            responseModel.reqeustType = (reqModel?.reqeustType)!
        } else if (reqModel?.reqeustType.value(forKey: Constants.SEARCH_STOCK_QUERY_LOCATION_WISE_ITEM) != nil) {
            let postBody = reqModel?.reqeustType.value(forKey: Constants.SEARCH_STOCK_QUERY_LOCATION_WISE_ITEM) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Stock/ItemStockLocationWiseDetails/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            let res = performPostArrayRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                let keyEnum = res.keyEnumerator()
                while let key = keyEnum.nextObject() {
                    let dic = res.value(forKey: key as! String) as! NSDictionary
                    let code = dic.value(forKey: Constants.ITEM_LOCATION) as! String
                    responseDic.setObject(dic, forKey: code as NSCopying)
                }
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.SEARCH_STOCK_QUERY_LOCATION_WISE_ITEM)
            responseModel.reqeustType = (reqModel?.reqeustType)!
        }
        return responseModel
    }
}
