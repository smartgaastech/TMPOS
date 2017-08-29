//
//  ViewController.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit
import UserNotifications

class LoginScreenView: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var txtUserNameBox: UITextField!
    @IBOutlet weak var txtPasswordBox: UITextField!
    
    let adminModel = AdminSettingModel.getInstance()
    let settingPageController = SettingPageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        txtUserNameBox.delegate = self
        txtPasswordBox.delegate = self
        adminModel.clearData()
        settingPageController.readAdminSettingData()
        adminModel.deviceUdid = (UIDevice.current.identifierForVendor?.uuidString)!
         
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkAnyDeviceUDIDExistsInLocalDB()-> String{
        var macid = ""
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let databasePath = dirPaths[0].appendingPathComponent("joptics.db").path
        if filemgr.fileExists(atPath: databasePath as String) {
            let touchymPOSDB = FMDatabase(path: databasePath as String)
            if touchymPOSDB == nil {
                print("Error: \(touchymPOSDB?.lastErrorMessage())")
            }else{
                if (touchymPOSDB?.open())! {
                    /*let sql_crt_stmt = "CREATE TABLE IF NOT EXISTS TOUCHYMPOS_COUNTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, POSCNT_UDID TEXT, POSCNT_LOCN_CODE TEXT, POSCNT_NO TEXT)"
                    if !(touchymPOSDB?.executeStatements(sql_crt_stmt))! {
                        print("Error: \(touchymPOSDB?.lastErrorMessage())")
                    }*/
                    let sql_sel_stmt = "SELECT POSCNT_UDID as macid from TOUCHYMPOS_COUNTER"
                    let results:FMResultSet? = touchymPOSDB?.executeQuery(sql_sel_stmt, withArgumentsIn: nil)
                    if results?.next() == true {
                        macid = (results?.string(forColumn: "macid"))!
                    }
                    touchymPOSDB?.close()
                } else {
                    print("Error: \(touchymPOSDB?.lastErrorMessage())")
                }
            }
        }
        return macid
    }
    
    func updateDeviceUDIDToLocalDB(model: LoginModel){
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let databasePath = dirPaths[0].appendingPathComponent("joptics.db").path
        if filemgr.fileExists(atPath: databasePath as String) {
            let touchymPOSDB = FMDatabase(path: databasePath as String)
            
                if (touchymPOSDB?.open())! {
                    let sql_crt_stmt = "CREATE TABLE IF NOT EXISTS TOUCHYMPOS_COUNTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, POSCNT_UDID TEXT, POSCNT_DEVICE_MODEL TEXT, POSCNT_DEVICE_NAME TEXT)"
                     if (touchymPOSDB?.executeStatements(sql_crt_stmt))! {
                        let insertSQL = "INSERT INTO TOUCHYMPOS_COUNTER (POSCNT_UDID, POSCNT_DEVICE_MODEL, POSCNT_DEVICE_NAME) VALUES ('\(model.macId)', '\(model.deviceModel)', '\(model.deviceName)')"
                        let result = touchymPOSDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                        if !result! {
                            print("Error: \(touchymPOSDB?.lastErrorMessage())")
                        }
                     }
                    touchymPOSDB?.close()
                } else {
                    print("Error: \(touchymPOSDB?.lastErrorMessage())")
                }
            
        } else{
            let touchymPOSDB = FMDatabase(path: databasePath as String)
            if touchymPOSDB == nil {
                print("Error: \(touchymPOSDB?.lastErrorMessage())")
            }else{
                if (touchymPOSDB?.open())! {
                    let sql_crt_stmt = "CREATE TABLE IF NOT EXISTS TOUCHYMPOS_COUNTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, POSCNT_UDID TEXT, POSCNT_DEVICE_MODEL TEXT, POSCNT_DEVICE_NAME TEXT)"
                    if (touchymPOSDB?.executeStatements(sql_crt_stmt))! {
                        let insertSQL = "INSERT INTO TOUCHYMPOS_COUNTER (POSCNT_UDID, POSCNT_DEVICE_MODEL, POSCNT_DEVICE_NAME) VALUES ('\(model.macId)', '\(model.deviceModel)', '\(model.deviceName)')"
                        let result = touchymPOSDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                        if !result! {
                            print("Error: \(touchymPOSDB?.lastErrorMessage())")
                        }
                    }
                    touchymPOSDB?.close()
                } else {
                    print("Error: \(touchymPOSDB?.lastErrorMessage())")
                }
            }
        }
    }
    
    @IBAction func buttonLoginTouchUpInside(_ sender: AnyObject) {
        
        let uName : String = txtUserNameBox.text!
        let pWord : String = txtPasswordBox.text!
        
        if uName == "" || pWord == "" {
            let alertController : UIAlertController = UIAlertController(title: "Invalid Credentials", message: "Enter Valid UserName and  Password",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if adminModel.serverUrl == "" || adminModel.companyCode == "" {
            let alertController : UIAlertController = UIAlertController(title: "Required AdminSettings", message: "Please GoTo Setting Page and enter required data",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Any other validation we can do here.
        let loginModel = LoginModel()
        loginModel.userName = uName
        loginModel.password = pWord
        loginModel.macId = adminModel.deviceUdid
        loginModel.companyCode = adminModel.companyCode
        loginModel.deviceName = UIDevice.current.name
        loginModel.deviceModel = UIDevice.current.model
        
        if(checkAnyDeviceUDIDExistsInLocalDB() != ""){
            loginModel.macId = checkAnyDeviceUDIDExistsInLocalDB()
        }else{
            updateDeviceUDIDToLocalDB(model: loginModel)
        }
        
        let loginController = LoginScreenController()
        let message = loginController.performSyncRequest(model: loginModel)
        let cmpResult = message.caseInsensitiveCompare("success")
        if cmpResult.rawValue == 0 {
            adminModel.userDataDic.setValue(uName, forKey: Constants.LOGGED_USER_NAME)
            //let userDefault = NSUserDefaults.standardUserDefaults()
            //userDefault.removeObjectForKey(Constants.LOGGED_USER_NAME)
            //userDefault.setValue(self.txtUserNameBox.text, forKey: Constants.LOGGED_USER_NAME)
            self.txtUserNameBox.text = ""
            self.txtPasswordBox.text = ""
            //var appTimer: Timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            self.dismiss(animated: true, completion:nil)
            
            //let filemgr = FileManager.default
            //let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            
            //let databasePath = dirPaths[0].appendingPathComponent("joptics.db").path
            
            //if !filemgr.fileExists(atPath: databasePath as String) {
                
                /*let contactDB = FMDatabase(path: databasePath as String)
                
                if contactDB == nil {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }
                
                if (contactDB?.open())! {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS TOUCHYMPOS_COUNTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, POSCNT_UDID TEXT, POSCNT_DEVICE_MODEL TEXT, POSCNT_DEVICE_NAME TEXT)"
                    if !(contactDB?.executeStatements(sql_stmt))! {
                        print("Error: \(contactDB?.lastErrorMessage())")
                    }
                    contactDB?.close()
                } else {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }*/
            //} else {
                
                /*let contactDB = FMDatabase(path: databasePath as String)
                
                if contactDB == nil {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }
                
                if (contactDB?.open())! {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS TOUCHYMPOS_COUNTER (ID INTEGER PRIMARY KEY AUTOINCREMENT, POSCNT_UDID TEXT, POSCNT_DEVICE_MODEL TEXT, POSCNT_DEVICE_NAME TEXT)"
                    if !(contactDB?.executeStatements(sql_stmt))! {
                        print("Error: \(contactDB?.lastErrorMessage())")
                    }
                    contactDB?.close()
                } else {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }*/
                
                let version = lblVersion.text
                let resVerDic = loginController.performVersionCheck(model: loginModel) as! NSMutableDictionary
                if let val = resVerDic.value(forKey: "SUCCESS") {
                    let realVersion = resVerDic.value(forKey: "VERSION") as! String
                    if version == realVersion {
                        
                    }else{
                        
                        let url = URL(string: "itms-services://?action=download-manifest&amp;url=https://sites.google.com/site/tmposdownload/manifest.plist")
                        if UIApplication.shared.canOpenURL(url!) {
                            let alertController : UIAlertController = UIAlertController(title: "New Update Available", message: "Please update the application!",preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)

                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            } else {
                            // Fallback on earlier versions
                                UIApplication.shared.openURL(url!)
                            }
                        //If you want handle the completion block than
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                                    print("Open url : \(success)")
                                })
                            } else {
                            // Fallback on earlier versions
                                UIApplication.shared.openURL(url!)
                            }
                        }
                        
                    }
                }
                /*if let url = URL(string: "itms-services://?action=download-manifest&url=https://sites.google.com/site/tmposdownload/TouchymPOS.ipa"),
                    UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.openURL(url)
                }*/
                
                
            //}
            
            
        }
        else if(message == "User and Password is not valid"){
            let alertController : UIAlertController = UIAlertController(title: "Invalid Credentials", message: "Enter Valid UserName and  Password",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController : UIAlertController = UIAlertController(title: "Invalid Device", message: "Please contact Admin Team!",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    @available(iOS 10.0, *)
    func getWorkOrderNotifications() -> UNMutableNotificationContent{
        let locncode = adminModel.userDataDic.value(forKey: Constants.ADMIN_LOCATION_key) as! String
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
            let content = UNMutableNotificationContent()
            content.title = "Test Notification"
            content.subtitle = "Let see @" + locncode + " " + result
            content.body = "Testing the notification functionality"
            content.badge = 1
            return content
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBOutlet weak var butSample: UIButton!
    
    @IBAction func buttonTouchInside(_ sender: AnyObject) {
        let popoverContent = EmailPopoverView()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 500,height: 100)
        popover!.sourceView = butSample
        popover!.sourceRect = butSample.bounds
        popover?.permittedArrowDirections = .any
        self.present(nav, animated: true, completion: nil)
    }
}


