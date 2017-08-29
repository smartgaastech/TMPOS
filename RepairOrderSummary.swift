//
//  RepairOrderSummary.swift
//  TouchymPOS
//
//  Created by ESHACK on 8/1/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

//
//  WorkOrderSummary.swift
//  TouchymPOS
//
//  Created by ESHACK on 12/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit
import WebKit

class RepairOrderSummary: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var barButtonEmail: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    var roId = ""
    var mobile = ""
    
    @IBAction func printPage(_ sender: Any) {
        let url = URL(string: "http://citrix.aljaber.ae/reports/repairorder/?repairorder=" + roId)
        let stringurl = url?.absoluteString
        
        let pic = UIPrintInteractionController.shared
        let printInfo : UIPrintInfo = UIPrintInfo(dictionary: nil)
        
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = stringurl!
        
        pic.printInfo = printInfo
        pic.printFormatter =  webView.viewPrintFormatter()
        pic.showsPageRange = false
        
        pic.present(animated: true, completionHandler: nil)
    }
    
    
    @IBAction func btnTouchUp(_ sender: Any) {
        let url = URL(string: "http://citrix.aljaber.ae/reports/repairorder/?repairorder=" + roId)
        let stringurl = url?.absoluteString
        
        let pic = UIPrintInteractionController.shared
        let printInfo : UIPrintInfo = UIPrintInfo(dictionary: nil)
        
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = stringurl!
        
        pic.printInfo = printInfo
        pic.printFormatter =  webView.viewPrintFormatter()
        pic.showsPageRange = false
        
        pic.present(animated: true, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "http://citrix.aljaber.ae/reports/repairorder/?repairorder=441" )!))
    }
    
    @IBAction func btnEmail(_ sender: Any) {
        /*let popoverContent = EmailPopoverView()
         popoverContent.parentType = Constants.RX_GLASS
         let nav = UINavigationController(rootViewController: popoverContent)
         popoverContent.parentView = self
         nav.modalPresentationStyle = UIModalPresentationStyle.popover
         let popover = nav.popoverPresentationController
         popoverContent.preferredContentSize = CGSize(width: 500,height: 100)
         //popover!.sourceView = barButtonEmail
         //popover!.sourceRect = barButtonEmail.bounds
         popover?.permittedArrowDirections = .any
         self.present(nav, animated: true, completion: nil)
         */
        showErrorMsg("Sorry", message: "Development is on process!")
    }
    
    func showErrorMsg(_ title: String, message: String) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertController.removeFromParentViewController()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

