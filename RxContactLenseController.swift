//
//  RxContactLenseController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/12/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class RxContactLenseController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? RxContactLenseModel
        var responseModel : RxContactLenseModel?
        if(reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE) != nil) {
            let pm_sys_id = reqModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatientRXContactLensDetails/" + String(describing: pm_sys_id!) + "/RX"
            //let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatientRXContactLensDetails/188456/RX" //+ String(pm_sys_id!) + "/RX"            
            responseModel = performSearchByRxContactLensePmSysId(postEndPoint)
            responseModel!.reqeustType = (reqModel?.reqeustType)!
        }
        return responseModel!
    }
    
    func performSearchByRxContactLensePmSysId(_ url:String) -> RxContactLenseModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newResponseModel : RxContactLenseModel = RxContactLenseModel()
        let modelDic = newResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                let cuId: String = String(describing: dic.value(forKey: "PRXCL_SYS_ID")!)
                modelDic.setObject(dic, forKey: cuId as NSCopying)
            }
        } else {
            modelDic.setObject(errorMsg!, forKey:Constants.ERROR_RESPONSE as NSCopying)
        }
        return newResponseModel
    }
    
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let rxReqModel = model as? RxContactLenseModel
        var responseCuModel = RxContactLenseModel()
        if rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_CONTACT_LENS_INFO) != nil && rxReqModel?.reqeustType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = rxReqModel?.reqeustType.value(forKey: Constants.SAVE_RX_CONTACT_LENS_INFO) as! NSMutableDictionary
            let opType : String = rxReqModel!.reqeustType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "Patient/SavePatientRXContactLensDetails/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "Patient/UpdatePatientRXContactLensDetails/0"
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
