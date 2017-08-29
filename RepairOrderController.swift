//
//  RepairOrderController.swift
//  TouchymPOS
//
//  Created by ESHACK on 7/3/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class RepairOrderController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSaveOperation(_ model : BaseModel) -> BaseModel {
        let roModel = model as? RepairOrderModel
        var responseRoModel = RepairOrderModel()
        if roModel?.requestType.value(forKey: Constants.SAVE_REPAIR_ORDER) != nil && roModel?.requestType.value(forKey: Constants.OPERATION_TYPE) != nil  {
            let dataDic = roModel?.requestType.value(forKey: Constants.SAVE_REPAIR_ORDER) as! NSMutableDictionary
            let opType : String = roModel!.requestType.value(forKey: Constants.OPERATION_TYPE) as! String
            var postEndPoint : String!
            if opType == Constants.OPERATION_TYPE_ADD {
                postEndPoint = (adminModel.serverUrl) + "RepairOrder/CreateRepairOrder/0"
            } else if opType == Constants.OPERATION_TYPE_EDIT {
                postEndPoint = (adminModel.serverUrl) + "RepairOrder/EditRepairOrder/0"
            }
            //print(dataDic)
            let responseDic = performPostRequest(postEndPoint, postBody: dataDic)
            var errorMsg = responseDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            if errorMsg == nil {
                let status = responseDic.value(forKey: "Status") as? String
                if status != "Success" {
                    responseRoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseRoModel.responseResult = responseDic
                }
            } else {
                responseRoModel.responseResult.setValue("Error", forKey: Constants.ERROR_RESPONSE)
            }
            responseRoModel.requestType = (roModel?.requestType)!
        }else if(roModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) != nil) {
            let postBody : NSMutableDictionary = roModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/UpdateRepairOrderStatus/0"
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
            responseRoModel.responseResult.setValue(responseDic, forKey: Constants.FIND_REPAIR_ORDER_STATUSES)
            responseRoModel.requestType = (roModel?.requestType)!
        }
        return responseRoModel
    }

    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? RepairOrderModel
        var responseModel = RepairOrderModel()
        if(reqModel?.requestType.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) != nil){
            let postBody = reqModel?.requestType.value(forKey: Constants.DYNAMIC_CONTROL_TYPE_WISE) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/DynamicControlsDetails/0"
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
        }else if(reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER) != nil){
            let tempcus = reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_SALES_ORDER)  as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/SalesOrderDetails/0"
            let postBody = NSMutableDictionary()
            var responseDic = NSMutableDictionary()
            postBody.setValue(tempcus.value(forKey: Constants.TRANS_NO), forKey: "TRANS_NO")
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody) as! NSMutableDictionary
            if(res.value(forKey: "Status") as! String == "failed") {
                responseModel.responseResult.setValue("nil", forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
                responseModel.responseResult.setValue("success", forKey: Constants.ERROR_RESPONSE)
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.CU_SEARCH_BY_SALES_ORDER)
            responseModel.requestType = (reqModel?.requestType)!
            
        } else if(reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE) != nil) {
            let tempcus = reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)  as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/InvoiceDetails/0"
            let postBody = NSMutableDictionary()
            var responseDic = NSMutableDictionary()
            postBody.setValue(tempcus.value(forKey: Constants.TRANS_NO), forKey: "TRANS_NO")
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody) as! NSMutableDictionary
            //print(res.value(forKey: "Status") )
            if(res.value(forKey: "Status") == nil || res.value(forKey: "Status") as! String == "failed") {
                responseModel.responseResult.setValue("nil", forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
                responseModel.responseResult.setValue("success", forKey: Constants.ERROR_RESPONSE)
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.CU_SEARCH_BY_HISTORY_INVOICE)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) != nil) {
            
            let mobileNo : String = reqModel?.requestType.value(forKey: Constants.CU_SEARCH_BY_PHONE_NO) as! String
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/FindRepairOrder/0"
            let postBody = NSMutableDictionary()
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            postBody.setValue(mobileNo, forKey: "TPOSROD_PATIENT_MOBILE")
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
        } else if(reqModel?.requestType.value(forKey: Constants.FILTER_REPAIR_ORDER_STATUS) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FILTER_REPAIR_ORDER_STATUS) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/FilterRepairOrders/0"
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
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FILTER_REPAIR_ORDER_STATUS)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUSES) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/UpdateRepairOrderStatus/0"
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
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FIND_REPAIR_ORDER_STATUSES)
            responseModel.requestType = (reqModel?.requestType)!
        } else if(reqModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUS_CHECK) != nil) {
            let postBody : NSMutableDictionary = reqModel?.requestType.value(forKey: Constants.FIND_REPAIR_ORDER_STATUS_CHECK) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "RepairOrder/CheckRepairOrderStatus/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            var res = NSMutableDictionary()
            res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else {
                responseDic = res
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.FIND_REPAIR_ORDER_STATUS_CHECK)
            responseModel.requestType = (reqModel?.requestType)!
        }
        return responseModel
    }
    
}


