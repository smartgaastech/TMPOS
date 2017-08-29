//
//  RxLenseController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class RxGlassesController: BaseController {
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? RxGlassesModel
        var responseModel : RxGlassesModel?
        if(reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_RX_GLASSES) != nil) {
            let reqDic = reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_RX_GLASSES) as? NSMutableDictionary
            let pm_sys_id = reqDic?.value(forKey: Constants.PM_SYS_ID)
            let pm_cust_No = reqDic?.value(forKey: Constants.PM_CUST_NO)
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatientRXGlassesDetails/" + String(describing: pm_sys_id!) + "/" + String(describing: pm_cust_No!)
            responseModel = performSearchByRxContactLensePmSysId(postEndPoint)
            responseModel!.reqeustType = (reqModel?.reqeustType)!
        }
        return responseModel!
    }
    
    func performSearchByRxContactLensePmSysId(_ url:String) -> RxGlassesModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newResponseModel : RxGlassesModel = RxGlassesModel()
        let modelDic = newResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                let cuId: String = String(describing: dic.value(forKey: Constants.PRXG_SYS_ID)!)
                modelDic.setObject(dic, forKey: cuId as NSCopying)
            }
        } else {
            modelDic.setObject(errorMsg!, forKey:Constants.ERROR_RESPONSE as NSCopying)
        }
        return newResponseModel
    }
    
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let rxReqModel = model as? RxGlassesModel
        var responseCuModel = RxGlassesModel()
        if rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_GLASSES_INFO) != nil && rxReqModel?.reqeustType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_GLASSES_INFO) as! NSMutableDictionary
            let opType : String = rxReqModel!.reqeustType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "Patient/SavePatientRXGlassDetails/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "Patient/UpdatePatientRXGlassDetails/0"
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
