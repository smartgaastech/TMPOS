//
//  AdminSettingModel.swift
//  TouchymPOS
//
//  Created by user115796 on 2/28/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

open class AdminSettingModel: BaseModel {
    
    static let adminSetting : AdminSettingModel = AdminSettingModel()
    
    open var serverUrl : String = "http://citrix.aljaber.ae/evisionsoftpostest/api/"
    open var companyCode : String = ""
    public var locationCode : String = ""
    open var isUserSavedData : String = Constants.FALSE
    open var deviceUdid : String = ""
    var userDataDic = NSDictionary()
    var loggedUserName = ""
    
    /*public var serverUrl : String = ""
    public var counterCode : String = ""
    public var locationCode : String = ""
    public var companyCode : String = ""
    
    private override init() {
        self.serverUrl = ""
        self.counterCode = ""
        self.locationCode = ""
        self.companyCode = ""
        
    }*/
    
    open static func getInstance() -> AdminSettingModel {
        return adminSetting
    }
    
    func clearData() {
        deviceUdid = ""
        loggedUserName = ""
        
        userDataDic = NSDictionary()
    }
    
}
