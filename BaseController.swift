//
//  BaseLoginController.swift
//  TouchymPOS
//
//  Created by user115796 on 3/2/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

open class BaseController: Constants, NSURLConnectionDelegate, XMLParserDelegate {

    func performGetRequest(_ postEndPoint: String) -> NSDictionary {
        print("New Request Start :\(postEndPoint)")
        var responseDict:NSMutableDictionary = NSMutableDictionary()
        var errorMsg : String = ""
        
        do {
            guard let url = URL(string: postEndPoint) else {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let semphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    errorMsg = "Error: did not receive data"
                    semphore.signal()
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    errorMsg = "error calling GET on url : \(postEndPoint)"
                    semphore.signal()
                    return
                }
                do {
                    responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                semphore.signal()
            })
            task.resume()
            semphore.wait(timeout: DispatchTime.distantFuture)
            
        } catch let error as NSException {
            print(error)
            errorMsg = "General Caught Exception"
        }
        
        if(errorMsg != "") {
            responseDict.setObject(errorMsg, forKey: Constants.ERROR_RESPONSE as NSCopying)
        }
        print("New get Request End: ")
        return responseDict
    }
    
    func performArrayGetRequest(_ postEndPoint: String) -> NSDictionary {
        print("New attary get Request Start :\(postEndPoint)")
        let responseDict:NSMutableDictionary = NSMutableDictionary()
        var errorMsg : String = ""
        do {
            guard let url = URL(string: postEndPoint) else {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let semphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    errorMsg = "Error: did not receive data"
                    semphore.signal()
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    errorMsg = "error calling GET on url : \(postEndPoint)"
                    semphore.signal()
                    return
                }
                do {
                    let resArray:NSArray = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    let arrayCount:Int = resArray.count
                    if arrayCount > 0 {
                        print("The total No of response in array get get response array Size is : \(arrayCount)")
                        for index in 0..<arrayCount {
                            let row : NSDictionary = resArray[index] as! NSDictionary
                            responseDict.setObject(row, forKey: String(index) as NSCopying)
                        }
                    } else {
                        errorMsg = Constants.SEARCH_NO_RESULT
                    }
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                semphore.signal()
            })
            task.resume()
            semphore.wait(timeout: DispatchTime.distantFuture)
            
        } catch let error as NSException {
            print(error)
            errorMsg = "General Caught Exception"
        }
        
        if(errorMsg != "") {
            responseDict.setObject(errorMsg, forKey: Constants.ERROR_RESPONSE as NSCopying)
        }
        print("New array Request End:")
        return responseDict
    }
    
    
    func performPostRequest(_ postEndPoint: String, postBody : NSMutableDictionary) -> NSMutableDictionary {
        
        print("New post Request Start :\(postEndPoint)")
        var responseDict:NSMutableDictionary = NSMutableDictionary()
        var errorMsg : String = ""
        do {
            /*guard let url = URL(string: postEndPoint) else {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let urlRequest:NSMutableURLRequest  = NSMutableURLRequest(url: url)
            urlRequest.httpMethod = "POST"
            do {
                let jsonPostBody = try JSONSerialization.data(withJSONObject: postBody, options: .prettyPrinted)
                urlRequest.httpBody = jsonPostBody
            }
            catch {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)*/
            let semphore = DispatchSemaphore(value: 0)
 
            var request = URLRequest(url: URL(string: postEndPoint)!)
            request.httpMethod = "POST"
            let postString = "id=13&name=Jack"
            do{
            let jsonPostBody = try JSONSerialization.data(withJSONObject: postBody, options: .prettyPrinted)
            request.httpBody = jsonPostBody   //postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            }catch {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    semphore.signal()
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    semphore.signal()
                    return
                }
                
                do {
                    responseDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    print(responseDict)
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                semphore.signal()
            }
            task.resume()
            /*let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    errorMsg = "Error: did not receive data"
                    semphore.signal()
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    errorMsg = "error calling GET on url : \(postEndPoint)"
                    semphore.signal()
                    return
                }
                do {
                    responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    print(responseDict)
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                semphore.signal()
            })*/
            //task.resume()
            semphore.wait(timeout: DispatchTime.distantFuture)
            
            
        } catch let error as NSException {
            print(error)
            errorMsg = "General Caught Exception"
        }
        
        if(errorMsg != "") {
            responseDict.setObject(errorMsg, forKey: Constants.ERROR_RESPONSE as NSCopying)
        }
        
        print("New Post Request end :");
        return responseDict
    }
    
    func performPostArrayRequest(_ postEndPoint: String, postBody : NSMutableDictionary) -> NSMutableDictionary {
        print("New post Request Start :\(postEndPoint)")
        var responseDict:NSMutableDictionary = NSMutableDictionary()
        var errorMsg : String = ""
        do {
            /*guard let url = URL(string: postEndPoint) else {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let urlRequest:NSMutableURLRequest  = NSMutableURLRequest(url: url)
            urlRequest.httpMethod = "POST"
            do {
                let jsonPostBody = try JSONSerialization.data(withJSONObject: postBody, options: .prettyPrinted)
                urlRequest.httpBody = jsonPostBody
            }
            catch {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            let config = URLSessionConfiguration.default
            _ = URLSession(configuration: config)*/
            let semphore = DispatchSemaphore(value: 0)
            
            var request = URLRequest(url: URL(string: postEndPoint)!)
            request.httpMethod = "POST"
            let postString = "id=13&name=Jack"
            do{
                let jsonPostBody = try JSONSerialization.data(withJSONObject: postBody, options: .prettyPrinted)
                request.httpBody = jsonPostBody   //postString.data(using: .utf8)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
            }catch {
                print("Error: cannot create URL")
                responseDict.setObject("Error: cannot create URL", forKey: Constants.ERROR_RESPONSE as NSCopying)
                return responseDict
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    semphore.signal()
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    semphore.signal()
                    return
                }
                
                do {
                    let resArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    let arrayCount:Int = resArray.count
                    if arrayCount > 0 {
                        print("The total No of response in array get get response array Size is : \(arrayCount)")
                        for index in 0..<arrayCount {
                            let row : NSDictionary = resArray[index] as! NSDictionary
                            responseDict.setObject(row, forKey: String(index) as NSCopying)
                        }
                    } else {
                        errorMsg = Constants.SEARCH_NO_RESULT
                    }
                    print(responseDict)
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                semphore.signal()
            }
            task.resume()
            /*let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    errorMsg = "Error: did not receive data"
                    semphore.signal()
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    errorMsg = "error calling GET on url : \(postEndPoint)"
                    semphore.signal()
                    return
                }
                do {
                    let resArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    let arrayCount:Int = resArray.count
                    if arrayCount > 0 {
                        print("The total No of response in array get get response array Size is : \(arrayCount)")
                        for index in 0..<arrayCount {
                            let row : NSDictionary = resArray[index] as! NSDictionary
                            responseDict.setObject(row, forKey: String(index))
                        }
                    } else {
                        errorMsg = Constants.SEARCH_NO_RESULT
                    }
                    print(responseDict)
                } catch  {
                    print("error while trying to convert data to JSON")
                    errorMsg = "error while trying to convert data to JSON"
                    semphore.signal()
                    return
                }
                semphore.signal()
            })
            task.resume()*/
            semphore.wait(timeout: DispatchTime.distantFuture)            
        } catch let error as NSException {
            print(error)
            errorMsg = "General Caught Exception"
        }
        
        if(errorMsg != "") {
            responseDict.setObject(errorMsg, forKey: Constants.ERROR_RESPONSE as NSCopying)
        }
        print("New Post Request end :");
        return responseDict
    }
}
