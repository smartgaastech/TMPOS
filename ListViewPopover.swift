//
//  ListViewPopover.swift
//  TouchymPOS
//
//  Created by user115796 on 3/30/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class ListViewPopover: UIView, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var parentFrame : UIViewController!
    var parentField : UITextField!
    var dataDic : NSMutableDictionary!
    var resultUpdater : NSMutableDictionary!
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var okButton : UIButton!
    var cancelButton : UIButton!
    
    var searchActive = false
    var data = [String]()
    var filtteredData = [String]()
    let cuHomeScreenController = CustomerHomeScreenController()
    var searchType = ""
    var searchResult :NSMutableDictionary = NSMutableDictionary()
    var searchkeyResult = [String]()
    
    var parentView : UIViewController!
    
    var dataKey = [String]()
    
    init(frame: CGRect,parentFrame : UIViewController,parentField : UITextField,dataDic : NSMutableDictionary,type : String,resultUpdater : NSMutableDictionary) {
        super.init(frame: frame)
        self.parentFrame = parentFrame
        self.parentField = parentField
        self.dataDic = dataDic
        self.resultUpdater = resultUpdater
        self.searchType = type
        self.dataKey = dataDic.allKeys as! [String]
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: 400, height: 40)
        self.addSubview(searchBar)
        
        okButton = UIButton()
        okButton.backgroundColor = UIColor.cyan
        okButton.setTitle("OK", for: UIControlState())
        okButton.frame = CGRect(x: 300,y: 0,width: 90,height: 40)
        okButton.addTarget(self, action: #selector(ListViewPopover.butOkTouchUpInside), for: UIControlEvents.touchUpInside)
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.backgroundColor = UIColor.red
        cancelButton.frame = CGRect(x: 400, y: 0, width: 100, height: 40)
        cancelButton.addTarget(self, action: #selector(ListViewPopover.butCancelTouchUpInside), for: UIControlEvents.touchUpInside)
        //self.addSubview(okButton)
        self.addSubview(cancelButton)
        
        let codeLbl = UILabel()
        codeLbl.backgroundColor = UIColor.orange
        codeLbl.text = "Code"
        codeLbl.frame = CGRect(x: 0, y: 40, width: frame.width/2, height: 40)
        self.addSubview(codeLbl)
        
        let namelbl = UILabel()
        namelbl.backgroundColor = UIColor.cyan
        namelbl.text = "name"
        namelbl.frame = CGRect(x: (frame.width/2)+1, y: 40, width: (frame.width/2)-1, height: 40)
        self.addSubview(namelbl)
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 80, width: frame.width, height: frame.height-80)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = true
        tableView.register(ListViewPopUpCell.self, forCellReuseIdentifier: "Cell")
        self.addSubview(tableView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(searchBar.text == "") {
            searchActive = false
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        if(searchBar.text != "") {
            let searchTxt = searchBar.text
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
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == ""){
            searchResult.removeAllObjects()
            searchkeyResult.removeAll()
            tableView.reloadData()
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ListViewPopUpCell
        var comCode = dataKey[indexPath.row]
        if searchActive {
            comCode = filtteredData[indexPath.row]
        }
        cell.codeLbl.text = comCode
        cell.nameLbl.text = dataDic.value(forKey: comCode) as? String
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
        if searchType == Constants.LIST_VIEW_SEARCH_SALES_MAN {
            parentField.text = key
        }
        butCancelTouchUpInside()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func butCancelTouchUpInside() {
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.transitionCurlUp, animations: ({
        UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self, cache: true)
        }), completion: {
        (value : Bool)in
        self.removeFromSuperview()
        })
    }
    func butOkTouchUpInside() {
        self.isHidden = true
        self.removeFromSuperview()
    }
}

class ListViewPopUpCell : UITableViewCell {
    
    var codeLbl : UILabel!
    var nameLbl : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        codeLbl = UILabel()
        codeLbl.backgroundColor = UIColor.gray
        codeLbl.frame = CGRect(x: 2, y: 2, width: 250,height: 30)
        contentView.addSubview(codeLbl)
        
        nameLbl = UILabel()
        nameLbl.backgroundColor = UIColor.purple
        nameLbl.frame = CGRect(x: 251,y: 2,width: 249, height: 30)
        contentView.addSubview(nameLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
}
