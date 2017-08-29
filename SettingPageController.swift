//
//  SettingPageController.swift
//  TouchymPOS
//
//  Created by user115796 on 2/28/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class SettingPageController {
    
    let adminModel = AdminSettingModel.getInstance()
    func readAdminSettingData() {
        let fileManager = FileManager.default
        let path:String = getAdminSettingFilePath()
        if !((path ?? "").isEmpty) && fileManager.fileExists(atPath: path) {
            print(path)
            let dic = NSDictionary(contentsOfFile: path)
            if let val = dic?.value(forKey: Constants.ADMIN_URL_KEY) {
                adminModel.serverUrl = val as! String
            }
            if let val = dic?.value(forKey: Constants.ADMIN_COMPANY_KEY) {
                adminModel.companyCode =  val as! String
            }
        }
    }
    
    func saveAdminSettiDataToFile() -> Bool {
        let fileManager = FileManager.default
        let path:String = getAdminSettingFilePath()
        if !((path ?? "").isEmpty) && fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            }
            catch let error as NSError {
                print(error)
                return false
            }
        }
        let dic = NSMutableDictionary()
        dic.setObject(adminModel.serverUrl, forKey: Constants.ADMIN_URL_KEY as NSCopying)
        dic.setObject(adminModel.companyCode, forKey: Constants.ADMIN_COMPANY_KEY as NSCopying)
        dic.setObject(adminModel.locationCode, forKey: Constants.ADMIN_LOCATION_key as NSCopying)
        dic.write(toFile: path, atomically: true)
        return true
    }
    
    func needToGetAdminSettigFromUser() -> Bool {
        if(adminModel.serverUrl == "") {
            return true
        }
        if(adminModel.companyCode == "") {
            return true
        }
        return false
    }
    
    fileprivate func getAdminSettingFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as NSArray
        let directory = paths.firstObject as? NSString
        let path = directory?.appendingPathComponent(Constants.ADMIN_SETTING_FILE_NAME)
        return path!
    }
}
