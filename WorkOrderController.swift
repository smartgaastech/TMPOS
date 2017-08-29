//
//  WorkOrderController.swift
//  TouchymPOS
//
//  Created by ESHACK on 10/16/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class WorkOrderController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? WorkOrderModel
        var responseModel = WorkOrderModel()
        if(reqModel?.requestType.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) != nil){
            let postBody = reqModel?.requestType.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/DynamicControlsDetails/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            let res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) != nil){
            let tempcus = reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER)  as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/SalesOrderDetails/0"
            let postBody = NSMutableDictionary()
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            postBody.setValue(tempcus.value(forKey: Constants.TRANS_NO), forKey: "TRANS_NO")
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) != nil) {
            
                let mobileNo : String = reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! String
                let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/FindWorkOrder/0"
                let postBody = NSMutableDictionary()
                var responseDic : NSMutableDictionary = NSMutableDictionary()
                postBody.setValue(mobileNo, forKey: "TPOSWOD_PATIENT_MOBILE")
                var res = NSMutableDictionary()
                res = performPostArrayRequest(postEndPoint, postBody: postBody)
                if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                    responseDic = NSMutableDictionary()
                    responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseDic = res
                }
                responseModel.responseResult.setValue(responseDic, forKey: Constants.CU_SEARCH_BY_PHONE_NO)
                responseModel.requestType = (reqModel?.requestType)!
            
                //let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/FindPatient/" + mobileNo
                //responseModel = performSearchByPhoneRequest(postEndPoint)
                //responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/FilterWorkOrders/0"
            //let postBody = NSMutableDictionary()
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            var res = NSMutableDictionary()
            res = performPostArrayRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FILTER_WORK_ORDER_STATUS)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.FIND_WORK_ORDER_STATUSES) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FIND_WORK_ORDER_STATUSES) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/UpdateWorkOrderStatus/0"
            //let postBody = NSMutableDictionary()
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            var res = NSMutableDictionary()
            res = performPostArrayRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FIND_WORK_ORDER_STATUSES)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.FIND_WORK_ORDER_STATUS_CHECK) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FIND_WORK_ORDER_STATUS_CHECK) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/CheckWorkOrderStatus/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FIND_WORK_ORDER_STATUS_CHECK)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.LOCN_WORKORDER_NOTIFICATION) != nil){
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.LOCN_WORKORDER_NOTIFICATION) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "WorkOrder/WorkOrderNotifications/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.LOCN_WORKORDER_NOTIFICATION)
            responseModel.requestType = (reqModel?.requestType)!

        }
        
        return responseModel
    }
    
    /*func performSearchByPhoneRequest(_ url:String) -> WorkOrderModel{
        let responseDic = performArrayGetRequest(url)
        let errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
        let newCuResponseModel : WorkOrderModel = WorkOrderModel()
        let modelDic = newCuResponseModel.responseResult
        if(errorMsg == nil) {
            let keyEnum = responseDic.keyEnumerator()
            while let key = keyEnum.nextObject() {
                let dic = responseDic.value(forKey: key as! String) as! NSDictionary
                let cuId: NSNumber = dic.value(forKey: "JWH_NO") as! NSNumber
                modelDic.setObject(dic, forKey: cuId)
            }
        } else {
            modelDic.setObject(errorMsg!, forKey:Constants.ERROR_RESPONSE as NSCopying)
        }
        //print("In Perform SearchBy Phone : \(modelDic)")
        return newCuResponseModel
    }*/
    
    func perfromFilterWO(_ model : BaseModel) -> BaseModel {
        let woModel = model as? WorkOrderModel
        var responseWoModel = WorkOrderModel()
        if woModel?.requestType.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) != nil {
             let dataDic = woModel?.requestType.value(forKey: Constants.FILTER_WORK_ORDER_STATUS) as! NSMutableDictionary
            var postEndPoint : String!
            postEndPoint = (adminModel.serverUrl) + "WorkOrder/FilterWorkOrders/0"
            let responseDic = performPostArrayRequest(postEndPoint, postBody: dataDic)
            var errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil {
                let status = responseDic.value(forKey: "Status") as? String
                if status != "Success" {
                    responseWoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseWoModel.responseResult = responseDic
                }
            } else {
                responseWoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
            }
            responseWoModel.requestType = (woModel?.requestType)!
        }
        return responseWoModel
    }
    
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let woModel = model as? WorkOrderModel
        var responseWoModel = WorkOrderModel()
        if woModel?.requestType.value(forKey: Constants.SAVE_WORK_ORDER) != nil && woModel?.requestType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = woModel?.requestType.value(forKey: Constants.SAVE_WORK_ORDER) as! NSMutableDictionary
            let opType : String = woModel!.requestType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "WorkOrder/CreateWorkOrder/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "WorkOrder/EditWorkOrder/0"
            }
            print(dataDic)
            let responseDic = performPostRequest(postEndPoint, postBody: dataDic)
            var errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil {
                let status = responseDic.value(forKey: "Status") as? String
                if status != "Success" {
                    responseWoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseWoModel.responseResult = responseDic
                }
            } else {
                responseWoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
            }
            responseWoModel.requestType = (woModel?.requestType)!
        }
        return responseWoModel
    }
    
}
