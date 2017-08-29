//
//  CustomerHomeScreenController.swift
//  TouchymPOS
//
//  Created by user115796 on 2/28/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerHomeScreenController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let cuModel = model as? CustomerModel
        var responseCuModel = CustomerModel()
        if(cuModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) != nil) {
           let mobileNo : String = cuModel?.reqeustType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! String
           let postEndPoint : String = (adminModel.serverUrl) + "Patient/FindPatient/" + mobileNo
            responseCuModel = performSearchByPhoneRequest(postEndPoint)
            responseCuModel.reqeustType = (cuModel?.reqeustType)!
        }
        return responseCuModel
    }
    
    func performSearchByPhoneRequest(_ url:String) -> CustomerModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newCuResponseModel : CustomerModel = CustomerModel()
        let modelDic = newCuResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                let cuId: String = dic.value(forKey: "PM_CUST_NO") as! String
                modelDic.setObject(dic, forKey: cuId as NSCopying)
            }
        } else {
           modelDic.setObject(errorMsg!, forKey:Constants.ERROR_RESPONSE as NSCopying)
        }
        //print("In Perform SearchBy Phone : \(modelDic)")
        return newCuResponseModel
    }
    
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let cuModel = model as? CustomerModel
        var responseCuModel = CustomerModel()
        if cuModel?.reqeustType.value(forKey: Constants.CU_SAVE_CUSTOMER_INFO) != nil && cuModel?.reqeustType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = cuModel?.reqeustType.value(forKey: Constants.CU_SAVE_CUSTOMER_INFO) as! NSMutableDictionary
            let opType : String = cuModel!.reqeustType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "Patient/CreatePatient/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "Patient/SavePatientDetails/0"
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
            responseCuModel.reqeustType = (cuModel?.reqeustType)!
        }
        return responseCuModel
    }
    
}
