//
//  EmailPopoverView.swift
//  TouchymPOS
//
//  Created by ITTESTPC on 6/10/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class EmailPopoverView: UIViewController,UIPopoverPresentationControllerDelegate,UITextFieldDelegate  {

    
    var txtEmailIdBox : UITextField!
    var lblEmailId : UILabel!
    var buttonSendEmail: UIBarButtonItem!
    var buttonCncel : UIBarButtonItem!
    var parentView: UIViewController!
    var parentType :  String!
    var transId : String!
    var emailId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmailId = UILabel(frame: CGRect(x: 5, y: 50, width: 120, height: 40))
        lblEmailId.text = "Enter Email Id : "
        
        txtEmailIdBox = UITextField(frame: CGRect(x: 130, y: 50, width: 350, height: 40))
        txtEmailIdBox.placeholder = "Email Id"
        txtEmailIdBox.text = emailId
        txtEmailIdBox.font = UIFont.systemFont(ofSize: 15)
        txtEmailIdBox.borderStyle = UITextBorderStyle.roundedRect
        txtEmailIdBox.autocorrectionType = UITextAutocorrectionType.no
        txtEmailIdBox.keyboardType = UIKeyboardType.emailAddress
        txtEmailIdBox.returnKeyType = UIReturnKeyType.done
        txtEmailIdBox.clearButtonMode = UITextFieldViewMode.always;
        txtEmailIdBox.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txtEmailIdBox.autocapitalizationType = .none
        txtEmailIdBox.delegate = self
        
        view.addSubview(lblEmailId)
        view.addSubview(txtEmailIdBox)
        
        self.view.addSubview(txtEmailIdBox)
        buttonSendEmail = UIBarButtonItem(title: "SendMail", style: UIBarButtonItemStyle.done, target: self, action: #selector(EmailPopoverView.buttonSendEmailPressed(_:)))
        buttonCncel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EmailPopoverView.buttonCancelPressed(_:)))
        buttonSendEmail.title = "Send Mail"

        navigationItem.leftBarButtonItem = buttonCncel
        navigationItem.rightBarButtonItem = buttonSendEmail
    }
    
    func buttonSendEmailPressed(_ sender : AnyObject) {
        let mailModel = MailModel()
        let reqDic = NSMutableDictionary()
        reqDic.setValue(parentType, forKey: Constants.EMAIL_TYPE)
        reqDic.setValue(txtEmailIdBox.text, forKey: Constants.EMAIL_ID)
        reqDic.setValue(transId, forKey: Constants.TABLE_SYS_ID)
        mailModel.reqeustType.setValue(reqDic, forKey: Constants.SEND_MAIL_POST_REQUEST)
        let myController = MailContoller()
        let resModel = myController.performSyncRequest(mailModel) as! MailModel
        let resDic = resModel.responseResult.value(forKey: Constants.SEND_MAIL_POST_REQUEST) as! NSMutableDictionary
        if(resDic.value(forKey: Constants.ERROR_RESPONSE) == nil) {
            let alertController : UIAlertController = UIAlertController(title: "Mail sent Successfully", message: "You will get a mail soon.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let errorMsg = resDic.value(forKey: Constants.ERROR_RESPONSE) as? String
            let alertController : UIAlertController = UIAlertController(title: "Mail Cannot Send", message: "Server may down or Invalid mail id. Please try after some time.",preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismis",style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func buttonCancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
