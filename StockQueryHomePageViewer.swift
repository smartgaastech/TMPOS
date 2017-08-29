//
//  StockQueryHomePageViewer.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 5/15/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class StockQueryHomePageViewer: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtLocationBox: UITextField!
    @IBOutlet weak var txtMainGroupBox: UITextField!
    @IBOutlet weak var txtSubGroupBox: UITextField!
    @IBOutlet weak var txtFromItemBox: UITextField!
    @IBOutlet weak var txtToIteamBox: UITextField!
    
    var adminModel : AdminSettingModel!
    var searchResultDic : NSMutableDictionary!
    var searchType : String!
    var searchResultUpdater : NSMutableDictionary!
    var searchTag : Int!
    var plCode : String!
    var shouldMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adminModel = AdminSettingModel.getInstance()
        let countSetupDic = adminModel.userDataDic.value(forKey: Constants.COUNT_SETUP) as! NSDictionary
        plCode = countSetupDic.value(forKey: Constants.PL_CODE) as! String
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        txtLocationBox.isEnabled = false
        
        txtFromItemBox.delegate = self
        txtToIteamBox.delegate = self
        
        txtMainGroupBox.addTarget(self, action: #selector(StockQueryHomePageViewer.txtFieldTouchInside(_:)), for: UIControlEvents.touchDown)
        txtSubGroupBox.addTarget(self, action: #selector(StockQueryHomePageViewer.txtFieldTouchInside(_:)), for: UIControlEvents.touchDown)
        
        txtLocationBox.text = ((adminModel.value(forKey: "userDataDic") as! NSDictionary).value(forKey: Constants.LOCN_CODE) as! String)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StockQueryHomePageViewer.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(StockQueryHomePageViewer.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
        //txtMainGroupBox.text = "FRAM"
        //txtSubGroupBox.text="VOGU"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.view.frame.origin.y = 0
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if !shouldMove {
            return
        }
        shouldMove = false
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += (keyboardSize.height/2)
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if !shouldMove {
            return
        }
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= (keyboardSize.height/2)
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += (keyboardSize.height/2) - offset.height
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            return false
        } else if textField.tag == 2 {
            return false
        }
        shouldMove = true
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCompanyCodeListView" {
            let destVc = segue.destination as? CompanyCodeListView
            destVc?.dataDic = searchResultDic
            destVc?.parentView = self
            if(searchTag == 1) {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_STOCK_GROUP
                destVc?.parentUIField = txtMainGroupBox
            } else if(searchTag == 2) {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_STOCK_SUB_GROUP
                destVc?.parentUIField = txtSubGroupBox
            } else if(searchTag == 3) {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_STOCK_FROM_ITEM
                destVc?.parentUIField = txtFromItemBox
            } else if(searchTag == 4) {
                destVc?.searchType = Constants.LIST_VIEW_SEARCH_STOCK_TO_ITEM
                destVc?.parentUIField = txtToIteamBox
            }
            destVc?.parentViewName = Constants.VIEWER_STOCK_QUERY_DETAULS
        } else if segue.identifier == "ToSearchQueryDetailedViewer" {
            let destVc = segue.destination as? StockQueryDetailedPageViewer
            let searchReq = destVc!.pageDic
            destVc?.dataDic = searchResultDic
            searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
            searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
            searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
            searchReq.setValue(plCode, forKey: Constants.PL_CODE)
            var st = txtMainGroupBox.text
            if  (st != nil && st != "") {
                searchReq.setValue(st, forKey: Constants.MAIN_GROUP)
            } else {
                searchReq.setValue("", forKey: Constants.MAIN_GROUP)
            }
            
            st = txtSubGroupBox.text
            if (st != nil && st != "" ) {
                searchReq.setValue(st, forKey: Constants.SUB_GROUP)
            } else {
                searchReq.setValue("", forKey: Constants.SUB_GROUP)
            }
            
            st = txtFromItemBox.text
            if(st != nil && st != "") {
                searchReq.setValue(st, forKey: Constants.FROM_ITEM)
            } else {
                searchReq.setValue("", forKey: Constants.FROM_ITEM)
            }
            
            st = txtToIteamBox.text
            if(st != nil && st != "") {
                searchReq.setValue(st, forKey: Constants.TO_ITEM)
            } else {
                searchReq.setValue("", forKey: Constants.TO_ITEM)
            }
        }
    }
    
    @IBAction func ButResetTouchUpInside(_ sender: AnyObject) {
        txtFromItemBox.text = ""
        txtToIteamBox.text = ""
        txtSubGroupBox.text = ""
        txtMainGroupBox.text = ""
    }
    
    func txtFieldTouchInside(_ sender: UITextField) {
        
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        
        if sender.tag == 1 {
            searchTag = 1
            searchType = Constants.LIST_VIEW_SEARCH_STOCK_GROUP
            searchReq.setValue("", forKey: Constants.MAIN_GROUP)
            searchReq.setValue("", forKey: Constants.SUB_GROUP)
        } else if sender.tag == 2 {
            searchType = Constants.LIST_VIEW_SEARCH_STOCK_SUB_GROUP
            searchTag = 2
            searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
            searchReq.setValue("", forKey: Constants.SUB_GROUP)
        } else if sender.tag == 3 {
            searchType = Constants.LIST_VIEW_SEARCH_STOCK_FROM_ITEM
            searchTag = 3
            searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
            searchReq.setValue(txtSubGroupBox.text, forKey: Constants.SUB_GROUP)
            txtFromItemBox.resignFirstResponder()
        } else if sender.tag == 4 {
            searchType = Constants.LIST_VIEW_SEARCH_STOCK_TO_ITEM
            searchTag = 4
            searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
            searchReq.setValue(txtSubGroupBox.text, forKey: Constants.SUB_GROUP)
            txtToIteamBox.resignFirstResponder()
        }
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        reqDic.setValue(searchReq, forKey: searchType)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult.value(forKey: searchType) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = resDic
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Viewer Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    @IBAction func buttonMainGroupTouchUpInside(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        searchTag = 1
        searchType = Constants.LIST_VIEW_SEARCH_STOCK_GROUP
        searchReq.setValue("", forKey: Constants.MAIN_GROUP)
        searchReq.setValue("", forKey: Constants.SUB_GROUP)
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        reqDic.setValue(searchReq, forKey: searchType)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult.value(forKey: searchType) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = resDic
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Viewer Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonSubGroupTouchUpInside(_ sender: AnyObject) {
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        searchType = Constants.LIST_VIEW_SEARCH_STOCK_SUB_GROUP
        searchTag = 2
        searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
        searchReq.setValue("", forKey: Constants.SUB_GROUP)
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        reqDic.setValue(searchReq, forKey: searchType)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult.value(forKey: searchType) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = resDic
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Viewer Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func butFromIteamTouchUpInside(_ sender: AnyObject) {
        txtFromItemBox.resignFirstResponder()
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        
        searchType = Constants.LIST_VIEW_SEARCH_STOCK_FROM_ITEM
        searchTag = 3
        searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
        searchReq.setValue(txtSubGroupBox.text, forKey: Constants.SUB_GROUP)
        
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        reqDic.setValue(searchReq, forKey: searchType)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult.value(forKey: searchType) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = resDic
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Viewer Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    @IBAction func buttonItIteamTouchUpInside(_ sender: AnyObject) {
        txtToIteamBox.resignFirstResponder()
        let listModel = ListModel()
        let reqDic = listModel.reqeustType
        let searchReq = NSMutableDictionary()
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        
        searchType = Constants.LIST_VIEW_SEARCH_STOCK_TO_ITEM
        searchTag = 4
        searchReq.setValue(txtMainGroupBox.text, forKey: Constants.MAIN_GROUP)
        searchReq.setValue(txtSubGroupBox.text, forKey: Constants.SUB_GROUP)
    
        reqDic.setValue(searchType, forKey: Constants.LIST_VIEW_SEARCH_REQUEST)
        reqDic.setValue(searchReq, forKey: searchType)
        let myController = ListController()
        let resModel = myController.performSyncRequest(listModel) as! ListModel
        let resDic = resModel.responseResult.value(forKey: searchType) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = resDic
            performSegue(withIdentifier: "ToCompanyCodeListView", sender: self)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Viewer Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    @IBAction func buttonSearchUpInside(_ sender: AnyObject) {
        let stockQueryModel = StockQueryModel()
        let searchReq = NSMutableDictionary()
        
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COMP_CODE), forKey: Constants.COMP_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.LOCN_CODE), forKey: Constants.LOCN_CODE)
        searchReq.setValue(adminModel.userDataDic.value(forKey: Constants.COUNT_CODE), forKey: Constants.COUNT_CODE)
        searchReq.setValue(plCode, forKey: Constants.PL_CODE)
        
        var st = txtMainGroupBox.text
        if  (st != nil && st != "") {
            searchReq.setValue(st, forKey: Constants.MAIN_GROUP)
        } else {
            searchReq.setValue("", forKey: Constants.MAIN_GROUP)
        }
        
        st = txtSubGroupBox.text
        if (st != nil && st != "" ) {
            searchReq.setValue(st, forKey: Constants.SUB_GROUP)
        } else {
            searchReq.setValue("", forKey: Constants.SUB_GROUP)
        }
        
        st = txtFromItemBox.text
        if(st != nil && st != "") {
            searchReq.setValue(st, forKey: Constants.FROM_ITEM)
        } else {
            searchReq.setValue("", forKey: Constants.FROM_ITEM)
        }
        
        st = txtToIteamBox.text
        if(st != nil && st != "") {
            searchReq.setValue(st, forKey: Constants.TO_ITEM)
        } else {
            searchReq.setValue("", forKey: Constants.TO_ITEM)
        }
        
        let controller = StockQueryController()
        stockQueryModel.reqeustType.setValue(searchReq, forKey: Constants.SEARCH_STOCK_QUERY_ITEM)
        let resModel = controller.performSyncRequest(stockQueryModel) as! StockQueryModel
        let stockQueryItem = resModel.responseResult.value(forKey: Constants.SEARCH_STOCK_QUERY_ITEM) as! NSMutableDictionary
        if (stockQueryItem.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            searchResultDic = stockQueryItem
            performSegue(withIdentifier: "ToSearchQueryDetailedViewer", sender: self)
        } else {
            let errorMsg = stockQueryItem.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Stock Query Error Message", message: "Cannot featch data. Please try with proper input or Data may not be available.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
