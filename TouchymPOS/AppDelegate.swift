//
//  AppDelegate.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    let adminModel = AdminSettingModel.getInstance()
    var window: UIWindow?
    var timer: Timer?
    var woNotificationsDone : NSMutableDictionary = NSMutableDictionary()
    
    func startTimer() {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
                self?.scheduleLocal()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    
    deinit {
        stopTimer()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
                granted, error in
                
            })
            
                /*let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                let requestIdentifier = "TMPOS"
                //let locncode = adminModel.userDataDic.value(forKey: Constants.ADMIN_LOCATION_key) as! String
            var locncode = "013"
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let result = formatter.string(from: date)
                
                let content = UNMutableNotificationContent()
                content.title = "Test Notification"
                content.subtitle = "Let see @" + locncode + " " + result
                content.body = "Testing the notification functionality"
                content.badge = 1
                let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["TMPOS"])
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                })
        */
            
            //scheduleLocal()
            //startTimer()
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func scheduleLocal() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            
            let date = NSDate()
            let calendar = NSCalendar.current
            let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            
            content.title = "Late wake up call" + " " + String(hour) + " " + String(minutes)
            content.body = "The early bird catches the worm, but the second mouse gets the cheese."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default()
            
            var dateComponents = DateComponents()
            dateComponents.hour = 12
            dateComponents.minute = 34
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

