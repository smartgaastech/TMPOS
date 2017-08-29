//
//  LoginScreenController.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class LoginScreenController: BaseController {
    
    let adminModel = AdminSettingModel.getInstance()
    
    func performSyncRequest(model: BaseModel) -> String {
        let loginModel = model as? LoginModel
        let postEndPoint = adminModel.serverUrl+"Login/ValidateUser/0"
        let reqDic = NSMutableDictionary()
        reqDic.setValue(loginModel?.userName, forKey: Constants.UserName)
        reqDic.setValue(loginModel?.password, forKey: Constants.Password)
        reqDic.setValue(loginModel?.macId, forKey: Constants.MACID)
        reqDic.setValue(loginModel?.companyCode, forKey: Constants.CompCode)
        reqDic.setValue(loginModel?.deviceName, forKey: Constants.DeviceName)
        reqDic.setValue(loginModel?.deviceModel, forKey: Constants.DeviceModel)
        let dic = performPostRequest(postEndPoint, postBody: reqDic)
        if let error = dic.value(forKey: Constants.ERROR_RESPONSE) {
            return error as! String
        } else {
            let error = dic.value(forKey: Constants.LOGIN_STATUS) as? String
            if error == Constants.FAILED {
                return dic.value(forKey: Constants.LOGIN_MESSAGE) as! String
            } else {
                adminModel.userDataDic = dic
                adminModel.userDataDic.setValue(loginModel?.userName, forKey: Constants.LOGGED_USER_NAME)
                adminModel.userDataDic.setValue(dic.value(forKey: Constants.LOCN_CODE), forKey: Constants.ADMIN_LOCATION_key)

            }
        }
        return "Success"
    }
    
    func performVersionCheck(model: BaseModel) -> NSMutableDictionary {
        let postEndPoint = adminModel.serverUrl+"Login/loadVersionUpdate/0"
        let loginModel = model as? LoginModel
        let reqDic = NSMutableDictionary()
        let dic = performPostRequest(postEndPoint, postBody: reqDic)
        
        return dic
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
                
            }
        }
        return responseDic
    }
    
    func performSyncRequest() -> String {
        
        /*guard let url = NSURL(string: postEndPoint) else {
        print("Error: cannot create URL")
        return message
        }
        
        let urlRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let semphore = dispatch_semaphore_create(0)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
        (data, response, error) in
        guard let responseData = data else {
        print("Error: did not receive data")
        dispatch_semaphore_signal(semphore)
        return
        }
        guard error == nil else {
        print("error calling GET on /posts/1")
        print(error)
        dispatch_semaphore_signal(semphore)
        return
        }
        // parse the result as JSON, since that's what the API provides
        let post: NSDictionary
        do {
        post = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as! NSDictionary
        } catch  {
        print("error trying to convert data to JSON")
        dispatch_semaphore_signal(semphore)
        return
        }
        // now we have the post, let's just print it to prove we can access it
        let resuleStatus = post.valueForKey("Status") as? NSString
        
        // the post object is a dictionary
        // so we just access the title using the "title" key
        // so check for a title and print it if we have one
        if let postTitle = post["title"] as? String {
        print("The title is: " + postTitle)
        }
        message = resuleStatus!
        dispatch_semaphore_signal(semphore)
        })
        task.resume()
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER)*/
        //return message
        
        //let adminModel = AdminSettingModel.adminSetting
        
        //let loginData : LoginModel = model as! LoginModel
        
        let loginData = LoginModel()
        
        let getendpoint : String = "http://citrix.aljaber.ae/evisionsoftpos/api/Login/LoginValidate/ESHACK1/ESHACK786/001/013/001/AA"
        
        var message = "server Error"
        
        let post:NSString = "username=\(loginData.userName)&password=\(loginData.password)" as NSString
        
        let url:NSURL = NSURL(string: getendpoint)!
        
        let postData:NSData = post.data(using: String.Encoding.ascii.rawValue)! as NSData
        
        let postLength:String = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("doLogin - Request Constructed and the request is :")
        //print(request.HTTPBody)
        //print(request.HTTPBodyStream)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                message = "server error"
                return
                
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                message = "server error"
                return
            }
            // parse the result as JSON, since that's what the API provides
            
            let post: NSDictionary
            do {
                post = try JSONSerialization.jsonObject(with: responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                message = "server Error"
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
            message = "success"
        })
        task.resume()
        message = "success"
        return message;
    }
}
