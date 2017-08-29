//
//  CustomerDetailedInfoViewVisitCell.swift
//  TouchymPOS
//
//  Created by user115796 on 3/12/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class CustomerDetailedInfoViewVisitCell: CustomerDetailedViewCell {

    class var expandedHeight : CGFloat {get{return 140}}
    class var defaultHeight : CGFloat{get{return 40}}
    
    var customerInfo : NSMutableDictionary?
    var parentView :CustomerDetailedInfoViewer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func butHistoryTouchUpInside(_ sender: AnyObject) {
        
        let requestModel : CustomerHistoryModel =  CustomerHistoryModel()
        let controller : CustomerHistoryController = CustomerHistoryController()
        let sysId = customerInfo?.value(forKey: Constants.PM_SYS_ID)
        let custNo = customerInfo?.value(forKey: Constants.PM_CUST_NO)
        if  sysId != nil && custNo != nil {
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_HISTORY)
            let responseModel = controller.performSyncRequest(requestModel) as? CustomerHistoryModel
            parentView?.responseProtocolDelegate.setValue(responseModel?.responseResult, forKey: Constants.CU_SEARCH_BY_HISTORY)
        }
    }
    
    @IBAction func butRxContactLenseTouchUpInside(_ sender: AnyObject) {
        let requestModel : RxContactLenseModel =  RxContactLenseModel()
        let controller : RxContactLenseController = RxContactLenseController()
        let sysId = customerInfo?.value(forKey: Constants.PM_SYS_ID)
        if  sysId != nil {
            requestModel.reqeustType.setValue(sysId, forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
            let responseModel = controller.performSyncRequest(requestModel) as? RxContactLenseModel
            parentView?.responseProtocolDelegate.setValue(responseModel?.responseResult, forKey: Constants.CU_SEARCH_BY_RX_CONTACT_LENSE)
        }
    }
    
    @IBAction func butRxGlassesTouchUpInside(_ sender: AnyObject) {
        let requestModel : RxGlassesModel =  RxGlassesModel()
        let controller : RxGlassesController = RxGlassesController()
        let sysId = customerInfo?.value(forKey: Constants.PM_SYS_ID)
        let custNo = customerInfo?.value(forKey: Constants.PM_CUST_NO)
        if  sysId != nil && custNo != nil {
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_RX_GLASSES)
            let responseModel = controller.performSyncRequest(requestModel) as? RxGlassesModel
            parentView?.responseProtocolDelegate.setValue(responseModel?.responseResult, forKey: Constants.CU_SEARCH_BY_RX_GLASSES)
        }
    }
    
    @IBAction func butSlitKReadinTouchUpInside(_ sender: AnyObject) {
        let requestModel : SlitKReadingModel =  SlitKReadingModel()
        let controller : SlitKReadingController = SlitKReadingController()
        let sysId = customerInfo?.value(forKey: Constants.PM_SYS_ID)
        let custNo = customerInfo?.value(forKey: Constants.PM_CUST_NO)
        if  sysId != nil && custNo != nil {
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_SLIT_K_READING)
            let responseModel = controller.performSyncRequest(requestModel) as? SlitKReadingModel
            parentView?.responseProtocolDelegate.setValue(responseModel?.responseResult, forKey: Constants.CU_SEARCH_BY_SLIT_K_READING)
        }
    }
    
    @IBAction func butTrailTouchUpInside(_ sender: AnyObject) {
        let requestModel : TrailModel =  TrailModel()
        let controller : TrailController = TrailController()
        let sysId = customerInfo?.value(forKey: Constants.PM_SYS_ID)
        let custNo = customerInfo?.value(forKey: Constants.PM_CUST_NO)
        if  sysId != nil && custNo != nil {
            let reqDic : NSMutableDictionary = NSMutableDictionary()
            reqDic.setValue(sysId, forKey: Constants.PM_SYS_ID)
            reqDic.setValue(custNo, forKey: Constants.PM_CUST_NO)
            requestModel.reqeustType.setValue(reqDic, forKey: Constants.CU_SEARCH_BY_TRAIL)
            let responseModel = controller.performSyncRequest(requestModel) as? TrailModel
            parentView?.responseProtocolDelegate.setValue(responseModel?.responseResult, forKey: Constants.CU_SEARCH_BY_TRAIL)
        }
    }
    
    
    
    
    
    
    
}
