
//
//  CompanyCodeListView.swift
//  TouchymPOS
//
//  Created by user115796 on 4/14/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CompanyCodeListView: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

   
    @IBOutlet weak var tblListOfCodes: UITableView!
    @IBOutlet weak var companyCodeSearchBar: UISearchBar!
    var adminModel = AdminSettingModel.getInstance()
    var dataDic : NSMutableDictionary!
    var searchType = ""
    var parentView : UIViewController!
    
    var dataKey = [String]()
    var filtteredData = [String]()
    
    var resultUpdater : NSMutableDictionary!
    var type : String!
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var searchkeyResult = [String]()
    
    var imageDisplay = false
    var searchActive = false
    let settingPageController = SettingPageController()
    var parentViewName = ""
    
    var parentUIField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        companyCodeSearchBar.delegate = self
        tblListOfCodes.delegate = self
        tblListOfCodes.dataSource = self
        tblListOfCodes.separatorStyle = UITableViewCellSeparatorStyle.none
        tblListOfCodes.isScrollEnabled = true
        dataKey = dataDic.allKeys as! [String]
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(companyCodeSearchBar.text == "") {
            searchActive = false
            tblListOfCodes.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        companyCodeSearchBar.endEditing(true)
        companyCodeSearchBar.resignFirstResponder()
        if(companyCodeSearchBar.text != "") {
            let searchTxt = companyCodeSearchBar.text
            filtteredData = dataKey.filter({ (text:String) -> Bool in
                var tmp: NSString = text as NSString
                var range = tmp.range(of: searchTxt!, options: NSString.CompareOptions.caseInsensitive)
                if range.location == NSNotFound {
                    tmp = dataDic.value(forKey: text) as! String as NSString
                    range = tmp.range(of: searchTxt!, options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                }
                return range.location != NSNotFound
            })
            if(filtteredData.count == 0){
                searchActive = false
            } else {
                searchActive = true
            }
            
        }
        tblListOfCodes.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.companyCodeSearchBar.text == ""){
            searchResult.removeAllObjects()
            searchkeyResult.removeAll()
            tblListOfCodes.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtteredData.count
        }
        return dataKey.count
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let btn = UIButton(type: UIButtonType.custom) as UIButton
                btn.frame = CGRect(x: CGFloat(40), y: CGFloat(40), width: 350, height: 75)
                btn.setImage(UIImage(data: data), for: UIControlState())
                //self.PrescriptionScrollView.addSubview(btn)
                //self.imageView.image = UIImage(data: data)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ListViewTableCell
        var comCode = dataKey[indexPath.row]
        if searchActive {
            comCode = filtteredData[indexPath.row]
        }
        if imageDisplay {
            cell.lblCompCode.frame.size.height = 124.0
            cell.lblCompName.frame.size.height = 124.0
            cell.lblCompName.frame.size.width = 350.0
            cell.lblCompCode.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            cell.lblCompCode.textColor = UIColor.black
            cell.lblCompCode.font = UIFont(name: "Iowan Old Style Roman", size: 40)
            cell.lblCompCode.textAlignment = NSTextAlignment.center
            var url = String(adminModel.serverUrl)
            if (url?.contains("api/"))! {
                let endIndex = url?.index((url?.endIndex)!, offsetBy: -4)
                url = url?.substring(to: endIndex!)
            }
            var tempval = dataDic.value(forKey: comCode) as? String
            var folder = "UploadedFiles/" 
            url = url! + folder + tempval! as String?
            if let checkedUrl = URL(string: url!) {
                getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? checkedUrl.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() { () -> Void in
                        cell.lblCompName.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
                    }
                }
            }
            
            //cell.lblCompName.backgroundColor = UIColor(patternImage: UIImage(named: "SettingIcon")!)
        }else{
            cell.lblCompName.text = dataDic.value(forKey: comCode) as? String
        }
        cell.lblCompCode.text = comCode
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var key : String!
        if searchActive {
            key = filtteredData[indexPath.row]
        } else {
            key = dataKey[indexPath.row]
        }
        let dic = NSMutableDictionary()
        dic.setValue(key, forKey: Constants.COMP_CODE)
        if parentViewName == Constants.VIEWER_SETTING_PAGE_VIEWER {
            let view = parentView as? SettingPageViewer
            view!.protocolUpdater.setValue(dic, forKey: searchType)
        } else if parentViewName == Constants.VIEWER_ADD_EDIT_CUSTOMER_VIEWER {
            let view = parentView as? AddEditCustomerViewer
            view!.protocolUpdater.setValue(dic, forKey: searchType)
        } else if parentViewName == Constants.VIEWER_RX_GLASSES_DETAILED_VIEWER {
            let view = parentView as? RXGlassesDetailedView
            view!.searchResultUpdater.setValue(dic, forKey: searchType)           
        } else if parentViewName == Constants.VIEWER_RX_CONTACT_LENSE_DETAILED_VIEWER {
            let view = parentView as? RxContactLenseDetailView
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        }else if parentViewName == Constants.VIEWER_RX_TRAIL_DETAILED_VIEWER {
            let view = parentView as? TrailDetailedView
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if parentViewName == Constants.VIEWER_RX_SLIT_K_DETAILED_VIEWER {
            let view = parentView as? SlitAndKReadingDetailedView
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if parentViewName == Constants.VIEWER_WORK_ORDER_ADD_EDIT_VIEWER {
            let view = parentView as? AddEditWorkOrder
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if(parentViewName == Constants.VIEWER_STOCK_QUERY_DETAULS) {
            let view = parentView as? StockQueryHomePageViewer
            parentUIField.text = key
        } else if(parentViewName == Constants.VIEWER_WORK_ORDER_STATUS_HOME) {
            let view = parentView as? WorkOrderStatus
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if(parentViewName == Constants.VIEWER_WORK_ORDER_DETAILS) {
            let view = parentView as? WorkOrderDetails
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if(parentViewName == Constants.VIEWER_REPAIR_ORDER_ADD_EDIT_VIEWER){
            let view = parentView as? AddEditRepairOrder
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if(parentViewName == Constants.VIEWER_REPAIR_ORDER_STATUS_HOME) {
            let view = parentView as? RepairOrderStatus
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        } else if(parentViewName == Constants.VIEWER_REPAIR_ORDER_DETAILS) {
            let view = parentView as? RepairOrderDetails
            view!.searchResultUpdater.setValue(dic, forKey: searchType)
        }
        self.navigationController?.popViewController(animated: true)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if imageDisplay {
            return 130.0
        }else {
            return 42.0
        }
    }
}
