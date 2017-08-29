//
//  MailContoller.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 6/10/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class MailContoller: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(_ model: BaseModel) -> BaseModel {
        let reqModel = model as? MailModel
        var responseModel = MailModel()
        if(reqModel?.reqeustType.value(forKey: Constants.SEND_MAIL_POST_REQUEST) != nil) {
            let postBody = reqModel?.reqeustType.value(forKey: Constants.SEND_MAIL_POST_REQUEST) as! NSMutableDictionary
            let postEndPoint : String = (adminModel.serverUrl) + "Patient/SendEmail/0"
            var responseDic : NSMutableDictionary = NSMutableDictionary()
            let res = performPostRequest(postEndPoint, postBody: postBody)
            if(res.value(forKey: Constants.ERROR_RESPONSE) != nil) {
                responseDic = NSMutableDictionary()
                responseDic.setValue(res.value(forKey: Constants.ERROR_RESPONSE), forKey: Constants.ERROR_RESPONSE)
            } else if (res.value(forKey: "Message") != nil) {
                let msg = res.value(forKey: "Message") as! String
                if(msg.range(of: "Success")) == nil {
                    responseDic = NSMutableDictionary()
                    responseDic.setValue(msg, forKey: Constants.ERROR_RESPONSE)
                } else {
                    responseDic = NSMutableDictionary()
                    responseDic.setValue("Mail sent successfully.", forKey: Constants.SUCCESS)
                }
            }
            responseModel.responseResult.setValue(responseDic, forKey: Constants.SEND_MAIL_POST_REQUEST)
            responseModel.reqeustType = (reqModel?.reqeustType)!
        }
        return responseModel
    }
}
