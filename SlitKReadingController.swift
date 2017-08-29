//
//  SlitKReadingController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/16/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class SlitKReadingController: BaseController {
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? SlitKReadingModel
        var responseModel : SlitKReadingModel?
        if(reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_SLIT_K_READING) != nil) {
            let reqDic = reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_SLIT_K_READING) as? NSMutableDictionary
            let pm_sys_id = reqDic?.value(forKey: Constants.PM_SYS_ID)
            let pm_cust_No = reqDic?.value(forKey: Constants.PM_CUST_NO)
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatientSlitKReadingsDetails/" + String(describing: pm_sys_id!) + "/" + String(describing: pm_cust_No!)
            responseModel = performSearchByRxContactLensePmSysId(postEndPoint)
            responseModel!.reqeustType = (reqModel?.reqeustType)!
        }
        return responseModel!
    }
    
    func performSearchByRxContactLensePmSysId(_ url:String) -> SlitKReadingModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newResponseModel : SlitKReadingModel = SlitKReadingModel()
        let modelDic = newResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                let cuId: String = String(describing: dic.value(forKey: Constants.PRXSKR_SYS_ID)!)
                modelDic.setObject(dic, forKey: cuId as NSCopying)
            }
        } else {
            modelDic.setObject(errorMsg!, forKey:Constants.ERROR_RESPONSE as NSCopying)
        }
        return newResponseModel
    }
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let rxReqModel = model as? SlitKReadingModel
        var responseCuModel = SlitKReadingModel()
        if rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_SLIT_K_READIND_INFO) != nil && rxReqModel?.reqeustType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_SLIT_K_READIND_INFO) as! NSMutableDictionary
            let opType : String = rxReqModel!.reqeustType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "Patient/SavePatientRXSlitKReading/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "Patient/UpdatePatientRXSlitKReading/0"
            }
            let responseDic = performPostRequest(postEndPoint, postBody: dataDic)
            var errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil {
                let status = responseDic.value(forKey: "Status") as? String
                if status != "success" {
                    responseCuModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseCuModel.responseResult = responseDic
                }
            } else {
                responseCuModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
            }
            responseCuModel.reqeustType = (rxReqModel?.reqeustType)!
        }
        return responseCuModel
    }
}
