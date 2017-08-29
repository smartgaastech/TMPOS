//
//  SettingPageViewer.swift
//  TouchymPOS
//
//  Created by user115796 on 2/27/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class SettingPageViewer: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtServerUrlBox: UITextField!
    @IBOutlet weak var txtLocationCodeBox: UITextField!
    @IBOutlet weak var txtCouterCodeBox: UITextField!
    @IBOutlet weak var txtCompanyCodeBox: UITextField!
    
    var searchType : String = ""
    var searcResultDic : NSMutableDictionary = NSMutableDictionary()
    var protocolUpdater : NSMutableDictionary = NSMutableDictionary()
    var searchTxtBox : UITextField!
    
    @IBOutlet weak var dateNeedToDelete: UITextField!
    let adminModel = AdminSettingModel.adminSetting
    let myController = SettingPageController()
    
    override func viewDidLoad() {
        searcResultDic.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        txtServerUrlBox.delegate = self
        txtCompanyCodeBox.delegate = self
        
        txtLocationCodeBox.isEnabled = false
        txtCouterCodeBox.isEnabled = false
        
        //dateNeedToDelete.delegate = self
        
        txtCompanyCodeBox.addTarget(self, action: #selector(SettingPageViewer.txtFieldTouchInside(_:)), for: UIControlEvents.touchDown)
        
        if(myController.needToGetAdminSettigFromUser()) {
            myController.readAdminSettingData()
        }
        txtServerUrlBox.text = adminModel.serverUrl
        if searchType == "" {
           txtCompanyCodeBox.text = adminModel.companyCode
        } else if searchType == Constants.LIST_VIEW_SEARCH_COMPANY_CODE {
            let dic = protocolUpdater.value(forKey: Constants.LIST_VIEW_SEARCH_COMPANY_CODE)
            txtCompanyCodeBox.text = (dic as AnyObject).value(forKey: Constants.COMP_CODE) as? String
        }
    }    
      
    @IBAction func butSaveTouchupInside(_ sender: AnyObject) {
        if(txtServerUrlBox.text == "" || txtCompanyCodeBox.text == "") {
            let alertController : UIAlertController = UIAlertController(title: "Required Values", message: "Please Enter all the fields",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        adminModel.serverUrl = txtServerUrlBox.text!
        adminModel.companyCode = txtCompanyCodeBox.text!
        var message : String = "Error while Saving Data!. Please try again."
        let isDataSaved : Bool = myController.saveAdminSettiDataToFile()
        if isDataSaved {
            message = "Data Saved Successfully."
        }
        let alertController : UIAlertController = UIAlertController(title: "Admin Setting Message", message: message ,preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func txtFieldTouchInside(_ sender : UITextField) {
        switch sender.tag {
        case Constants.TAG_ADMIN_SETTING_COMPANY_CODE:
            searchType = Constants.LIST_VIEW_SEARCH_COMPANY_CODE
            searchTxtBox = txtCompanyCodeBox
            break
        default: break
            
        }
        
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searcResultDic = resDic.value(forKey: searchType) as! NSMutableDictionary
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            //present a alret view.
        }
        /*let point = self.view.center
        let frame = CGRect(x: point.x/2, y: point.y/2, width: 500, height: 400)
        let dataDic = NSMutableDictionary()
        let resultDic = NSMutableDictionary()
        
        
        searchType = String(UTF8String: "CompanyCode")
        listView = ListViewPopover(frame: frame, parentFrame: self, parentField: searchTxtBox, dataDic: dataDic, type: searchType, resultUpdater: resultDic)
        listView.backgroundColor = UIColor.blackColor()
        listView.alpha = 0.9
        self.view.addSubview(listView)
        listView.hidden = true
        viewCurlUp(listView, animationTime: 4.0)*/
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCompanyCodeListView" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searcResultDic
            destVc?.parentView = self
            destVc?.searchType = searchType
            destVc?.parentViewName = Constants.VIEWER_SETTING_PAGE_VIEWER
        }
    }
    
    
    func viewCurlUp(_ view:UIView,animationTime:Float)
    {
        UIView.animate(withDuration: 2, delay: 1, options: UIViewAnimationOptions.transitionCurlDown, animations: ({
            self.view.addSubview(view)
            UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: view, cache: true)
        }), completion: nil)
        
        /*UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(animationTime))
        listView.hidden = false
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlDown, forView: view, cache: false)
        UIView.commitAnimations()*/
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case Constants.TAG_ADMIN_SETTING_COMPANY_CODE:
            return false
            
        case Constants.TAG_ADMIN_SETTING_LOCATION_CODE:
            return false
            
        case Constants.TAG_ADMIN_SETTING_COUNTER_CODE:
            return false
        default:
            return true
       }
    }
    @IBAction func doTxtDateTouchDown(_ sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DateViewPopOver")
        /*vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        presentViewController(vc, animated: true, completion:nil)*/
        //var popView = DateViewController()
        let controller = UIPopoverController(contentViewController: vc)
        controller.contentSize = CGSize(width: 400, height: 400)
        controller.present(from: sender.frame, in: self.view, permittedArrowDirections: .any, animated: true)
        
    }
    
    
    @IBAction func txtFieldGenderTouchDown(_ txtCuGenderBox: UITextField) {
        let popoverContent = TrueFalseOptionController()
        let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.parentView = self
        popoverContent.selectedDate = txtCuGenderBox
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 200, height: 50)
        popover!.sourceView = txtCuGenderBox
        popover!.sourceRect = txtCuGenderBox.bounds
        popover?.permittedArrowDirections = .up
        self.present(nav, animated: true, completion: nil)
    }
}
