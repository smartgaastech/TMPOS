//
//  OMPatientMaster.swift
//  TouchymPOS
//
//  Created by user115796 on 3/1/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

open class OMPatientMasterModel: BaseModel {
    
    open var PM_ADDRESS_1 : String = ""
    open var PM_ADDRESS_2 : String = ""
    open var PM_ADDRESS_3 : String = ""
    open var PM_ADDRESS_4 : String = ""
    open var PM_ADDRESS_5 : String = ""
    open var PM_CITY : String = ""
    open var PM_COMPANY : String = ""
    open var PM_COMP_CODE : String = ""
    open var PM_COUNTER_CODE : String = ""
    open var PM_COUNTRY : String = ""
    open var PM_CR_DT : String = ""
    open var PM_CR_UID : String = ""
    open var PM_CUST_CODE : String = ""
    open var PM_CUST_NAME : String = ""
    open var PM_CUST_NO : String = ""
    open var PM_DOB : String = ""
    open var PM_EMAIL : String = ""
    open var PM_FLEX_01 : String = ""
    open var PM_FLEX_02 : String = ""
    open var PM_FLEX_03 : String = ""
    open var PM_FLEX_04 : String = ""
    open var PM_FLEX_05 : String = ""
    open var PM_FLEX_06 : String = ""
    open var PM_FLEX_07 : String = ""
    open var PM_FLEX_08 : String = ""
    open var PM_FLEX_09 : String = ""
    open var PM_FLEX_10 : String = ""
    open var PM_FLEX_11 : String = ""
    open var PM_FLEX_12 : String = ""
    open var PM_FLEX_13 : String = ""
    open var PM_FLEX_14 : String = ""
    open var PM_FLEX_15 : String = ""
    open var PM_FLEX_16 : String = ""
    open var PM_FLEX_17 : String = ""
    open var PM_FLEX_18 : String = ""
    open var PM_FLEX_19 : String = ""
    open var PM_FLEX_20 : String = ""
    open var PM_FRZ_FLAG_NUM : String = ""
    open var PM_GENDER : String = ""
    open var PM_LOCN_CODE : String = ""
    open var PM_NATIONALITY : String = ""
    open var PM_NOTES : String = ""
    open var PM_OCCUPATION : String = ""
    open var PM_PATIENT_NAME : String = ""
    open var PM_PD_ORDER_DT : String = ""
    open var PM_PD_ORDER_NO : String = ""
    open var PM_PD_SYS_ID : String = ""
    open var PM_REGION : String = ""
    open var PM_REMARKS : String = ""
    open var PM_SM_CODE : String = ""
    open var PM_SYS_ID :  String = ""
    open var PM_TEL_MOB : String = ""
    open var PM_TEL_OFF : String = ""
    open var PM_TEL_RES : String = ""
    open var PM_UPD_DT : String = ""
    open var PM_UPD_UID : String = ""
    open var PM_ZIPCODE : String = ""
    
    override open func isEqual(_ object: Any?) -> Bool {
        if let otherObj = object as? OMPatientMasterModel {
            if otherObj.PM_SYS_ID != self.PM_SYS_ID {
                return false
            }
            if otherObj.PM_CUST_NO != self.PM_CUST_NO {
                return false
            }
            if otherObj.PM_CUST_NAME != self.PM_CUST_NAME {
                return false
            }
            if otherObj.PM_LOCN_CODE != self.PM_LOCN_CODE {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    override open var hashValue : Int {
        var result : Int
        result = self.PM_SYS_ID.hash
        result = (result * 31) + self.PM_CUST_NO.hash
        result = (result * 31) + self.PM_CUST_NAME.hash
        result = (result * 31) + self.PM_LOCN_CODE.hash
        return result
    }
}
