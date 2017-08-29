//
//  HomeScreenViewer.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit
import UserNotifications

class HomeScreenViewer: UIViewController, UNUserNotificationCenterDelegate {
    
    let adminSetting = AdminSettingModel.getInstance()
    //let plistUrl = "https://sites.google.com/site/tmposdownload/manifest.plist"
    //let installationUrl = "itms-services://?action=download-manifest&amp;url=https://sites.google.com/site/tmposdownload/manifest.plist"
    
    
    
    override func viewDidLoad() {
        UIApplication.shared.isIdleTimerDisabled = true
       self.navigationController?.setNavigationBarHidden(false, animated: true)
        if #available(iOS 10.0, *) {
            //let center = UNUserNotificationCenter.current()
            //center.removeAllPendingNotificationRequests()
            self.scheduleLocal()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var timer = appDelegate.timer
            timer = Timer.scheduledTimer(withTimeInterval: 150.0, repeats: true) { [weak self] _ in
                self?.scheduleLocal()
            }
            /*let workOrderTimer = WorkOrderTimer()
            
            var timerWO = Timer.scheduledTimer(timeInterval: 0,
                                                               target: workOrderTimer,
                                                               selector: Selector("printFrom1To1000"),
                                                               userInfo: nil,
                                                               repeats: true
            )
            timerWO.fire()*/
            
        }
        // or you can remove specifical notification:
        // center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])

        //super.viewDidLoad()
    }
    
    @IBAction func btnTransactionTouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func btnRegularCustomerTouchUpInside(_ sender: Any) {
        //scheduleLocal()
        /*var localNotification = UILocalNotification()
        localNotification.fireDate = Date()
        localNotification.alertBody = "Hey, you must go shopping, remember?"
        localNotification.alertAction = "View List"
        localNotification.category = "shoppingListReminderCategory"
        
        UIApplication.shared.scheduleLocalNotification(localNotification)*/
    }
    
    @available(iOS 10.0, *)
    func getContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        return content
    }
    
    func scheduleLocal() {
        let locncodeval = adminSetting.userDataDic.value(forKey: Constants.ADMIN_LOCATION_key)
        if locncodeval != nil {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                //center.removeAllPendingNotificationRequests()
            
                let workordermodel = WorkOrderModel()
                let controller = WorkOrderController()
                let searchReq = NSMutableDictionary()
                searchReq.setValue(locncodeval, forKey: Constants.LOCN_CODE)
                workordermodel.requestType.setValue(searchReq, forKey: Constants.LOCN_WORKORDER_NOTIFICATION)
                let resModel = controller.performSyncRequest(workordermodel) as! WorkOrderModel
                let resDic = resModel.responseResult
                let workOrders = resDic.value(forKey: Constants.LOCN_WORKORDER_NOTIFICATION) as! NSMutableDictionary
                var notifications = NSMutableDictionary()
                if workOrders.value(forKey: "NOTIFICATION")  != nil {
                    if workOrders["NOTIFICATION"] is NSNull {
                        // do something with null JSON value here
                    }else {
                        notifications = workOrders.value(forKey: "NOTIFICATION") as! NSMutableDictionary
                    }
                }
                //let notifications = workOrders.value(forKey: "NOTIFICATION") as! NSMutableDictionary
                for contentval in notifications.allKeys {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let woNotDone = appDelegate.woNotificationsDone as! NSMutableDictionary
                    //let value = woNotDone[contentval] != nil
                    
                    if let val = woNotDone[contentval] {
                        
                    }else {
                    
                        let tempval = notifications.value(forKey: contentval as! String) as! NSMutableDictionary
                        let content = UNMutableNotificationContent()
                    
                        let date = NSDate()
                        let calendar = NSCalendar.current
                        let hour = calendar.component(.hour, from: date as Date)
                        let minutes = calendar.component(.minute, from: date as Date)
                    
                        let temp = locncodeval as! String
                        content.title = tempval.value(forKey: "title") as! String //"Late wake up call @" + temp + " " + String(hour) + " " + String(minutes)
                        content.subtitle = tempval.value(forKey: "subtitle") as! String  //"The early bird catches the worm, but the second mouse gets the cheese."
                        content.body = tempval.value(forKey: "message") as! String
                        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
                        //content.categoryIdentifier = "alarm"
                        //content.userInfo = ["customData": "fizzbuzz"]
                        content.sound = UNNotificationSound.default()
                    
                        /*var dateComponents = DateComponents()
                         dateComponents.hour = 12
                         dateComponents.minute = 34
                         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)*/
                    
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        center.add(request)
                        woNotDone.setValue(notifications.value(forKey: contentval as! String), forKey: contentval as! String)
                    }
                }
                
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}
