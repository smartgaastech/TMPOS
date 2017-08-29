
//
//  CustomerHistoryController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/14/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHistoryController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? CustomerHistoryModel
        var responseModel : CustomerHistoryModel?
        if(reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY) != nil) {
            let reqDic = reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY) as? NSMutableDictionary
            let pm_sys_id = reqDic?.value(forKey: Constants.PM_SYS_ID)
            let pm_cust_No = reqDic?.value(forKey: Constants.PM_CUST_NO)
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatientHistory/" + String(describing: pm_sys_id!) + "/" + String(describing: pm_cust_No!)
            responseModel = performSearchByRxContactLensePmSysId(postEndPoint)
            responseModel!.reqeustType = (reqModel?.reqeustType)!
        } else if (reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER) != nil) {
            responseModel = performSearchBySalesOrder(reqModel!)
        } else if (reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) != nil) {
            responseModel = performSearchByInvoiceNumber(reqModel!)
        }
        return responseModel!
    }
    
    func performSearchByRxContactLensePmSysId(_ url:String) -> CustomerHistoryModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newResponseModel : CustomerHistoryModel = CustomerHistoryModel()
        let modelDic = newResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                modelDic.setObject(dic, forKey: key as! String as NSCopying)
            }
        } else {
            modelDic.setObject(errorMsg!, forKey: Constants.ERROR_RESPONSE as NSCopying)
        }
        return newResponseModel
    }
    
    func performSearchBySalesOrder(_ model : CustomerHistoryModel) -> CustomerHistoryModel{
        var responseModel = CustomerHistoryModel()
        let reqDic = model.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER) as? NSMutableDictionary
        let pm_sales = reqDic?.value(forKey: Constants.PV_SalesOrderNo)
        let postEndPoint : String = (adminModel.serverUrl) + "Patient/SalesOrderDetails/0"
        let postBody = NSMutableDictionary()
        postBody.setValue(pm_sales, forKey: "TRANS_NO")
        var resDic = NSMutableDictionary()
        resDic = performPostRequest(postEndPoint, postBody: postBody)
        responseModel.reqeustType = model.reqeustType
        responseModel.responseResult.setValue(resDic, forKey: Constants.CU_SEARCH_BY_HISTORY_SALES_ORDER)
        return responseModel
    }
    
    func performSearchByInvoiceNumber(_ reqModel : CustomerHistoryModel) -> CustomerHistoryModel {
        var responseModel = CustomerHistoryModel()
        let reqDic = reqModel.reqeustType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) as? NSMutableDictionary
        let pm_sales = reqDic?.value(forKey: Constants.PV_InvoiceNo)
        let postEndPoint : String = (adminModel.serverUrl) + "Patient/InvoiceDetails/0"
        let postBody = NSMutableDictionary()
        postBody.setValue(pm_sales, forKey: "TRANS_NO")
        var resDic = NSMutableDictionary()
        resDic = performPostRequest(postEndPoint, postBody: postBody)
        responseModel.reqeustType = reqModel.reqeustType
        responseModel.responseResult.setValue(resDic, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
        return responseModel
    }
}
