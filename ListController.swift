//
//  ListController.swift
//  TouchymPOS
//
//  Created by user115796 on 4/14/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class ListController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    let countryISDCodeDic = NSMutableDictionary()

    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        
        let listModel = model as! ListModel
        let req = listModel.reqeustType
        let responseDic = listModel.responseResult
        var postEndPoint = ""
        let searchType = req.value(forKey: Constants.LIST_VIEW_SEARCH_REQUEST) as! String
        if(Constants.LIST_VIEW_SEARCH_COMPANY_CODE == searchType) {
            postEndPoint = (adminModel.serverUrl) + "LOV/comp"
            responseDic.setValue(getListOfValues(postEndPoint),forKey: searchType)
        } else if Constants.LIST_VIEW_SEARCH_LOCATION_CODE == searchType {
            postEndPoint = (adminModel.serverUrl) + "LOV/locn"
            responseDic.setValue(getListOfValues(postEndPoint),forKey:  searchType)
        } else if Constants.LIST_VIEW_SEARCH_SALES_MAN == searchType {
            postEndPoint = (adminModel.serverUrl) + "LOV/SalesmanListForLocationCounter/0"
            let postBody = req.value(forKey: searchType) as! NSMutableDictionary
            responseDic.setValue(getListOfValuesByPost(postEndPoint, postBody: postBody),forKey: searchType)
        } else if (Constants.LIST_VIEW_SEARCH_STOCK_GROUP == searchType  || Constants.LIST_VIEW_SEARCH_STOCK_SUB_GROUP == searchType
            || Constants.LIST_VIEW_SEARCH_STOCK_FROM_ITEM ==  searchType || Constants.LIST_VIEW_SEARCH_STOCK_TO_ITEM == searchType) {
            postEndPoint = (adminModel.serverUrl) + "Stock/ItemGroup/0"
            let postBody = req.value(forKey: searchType) as! NSMutableDictionary
            responseDic.setValue(getListOfValuesByPost(postEndPoint, postBody: postBody),forKey: searchType)
        } else if (Constants.LIST_VIEW_SEARCH_WORKORDER_STATUS == searchType) {
            postEndPoint = (adminModel.serverUrl) + "LOV/wostatus"
            responseDic.setValue(getListOfValues(postEndPoint),forKey: searchType)
        } else if (Constants.LIST_VIEW_SEARCH_REPAIRORDER_STATUS == searchType) {
            postEndPoint = (adminModel.serverUrl) + "LOV/rostatus"
            responseDic.setValue(getListOfValues(postEndPoint),forKey: searchType)
        } else if (Constants.LIST_VIEW_SEARCH_COUNTRY == searchType) {
            postEndPoint = (adminModel.serverUrl) + "LOV/country"
            responseDic.setValue(getListOfValues(postEndPoint),forKey: searchType)
            responseDic.setValue(countryISDCodeDic, forKey: "ISDCodes")
        }
        
        return listModel
    }
    
    func getListOfValues(_ postEndPoint : String) -> NSMutableDictionary {
        var responseDic : NSMutableDictionary!
        let res = performArrayGetRequest(postEndPoint)
        if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
            responseDic = NSMutableDictionary()
            responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
        } else {
            responseDic = getResponseResult(res)
        }
        return responseDic
    }
    
    func getResponseResult(_ result : NSDictionary) -> NSMutableDictionary {
        let responseDic = NSMutableDictionary()
        let keyEnum = result.keyEnumerator()
        while let key = keyEnum.nextObject() {
            let dic = result.value(forKey: key as! String) as! NSDictionary
            let code: String = dic.value(forKey: Constants.LOV_CODE) as! String
            let value: String = dic.value(forKey: Constants.LOV_NAME) as! String
            responseDic.setValue(value, forKey: code)
            if let isd = dic.value(forKey: Constants.LOV_VALUE)  {
                countryISDCodeDic.setValue(isd, forKey: code)
            }
        }
        return responseDic
    }
    
    func getListOfValuesByPost(_ postEndPoint : String, postBody: NSMutableDictionary) -> NSMutableDictionary {
        var responseDic : NSMutableDictionary = NSMutableDictionary()
        let res = performPostArrayRequest(postEndPoint, postBody: postBody)
        
        if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
            responseDic = NSMutableDictionary()
            responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
        } else {
            let keyEnum = res.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = res.value(forKey: key as! String) as! NSDictionary
                let code = dic.value(forKey: Constants.LOV_CODE) as! String
                let value = dic.value(forKey: Constants.LOV_NAME) as! String
                responseDic.setObject(value, forKey: code as NSCopying)
            }
        }
        return responseDic
    }
    
    
}
