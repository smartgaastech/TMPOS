//
//  PrescriptionTypeController.swift
//  TouchymPOS
//
//  Created by ESHACK on 10/19/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class PrescriptionTypeController: UIViewController {
    
    var txtPrescriptionType : UITextField!
    var lblPrescriptionTypeNumber : UILabel!
    var parentView : UIViewController!
    var btnRxContactLens : UIButton!
    var btnRxGlasses : UIButton!
    var btnSlitKReadings : UIButton!
    var btnTrialDetails : UIButton!
    var btnCancel : UIBarButtonItem!
    var fromWorkOrderStatusPage : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRxContactLens = UIButton(type: UIButtonType.system) as UIButton
        btnRxContactLens.frame = CGRect(x: 0, y: 50, width: 150, height: 30)
        btnRxContactLens.backgroundColor = UIColor.white
        btnRxContactLens.titleLabel?.textColor = UIColor.white
        btnRxContactLens.setTitle("ContactLenses", for: UIControlState())
        btnRxContactLens.addTarget(self, action: #selector(PrescriptionTypeController.btnRxContactLensPressed), for: .touchDown)
        
        btnRxGlasses = UIButton(type: UIButtonType.system) as UIButton
        btnRxGlasses.frame = CGRect(x: 0, y: 81, width: 150, height: 30)
        btnRxGlasses.backgroundColor = UIColor.white
        btnRxGlasses.titleLabel?.textColor = UIColor.white
        btnRxGlasses.setTitle("StockLenses", for: UIControlState())
        btnRxGlasses.addTarget(self, action: #selector(PrescriptionTypeController.btnStockLensesPressed), for: .touchDown)
        
        btnSlitKReadings = UIButton(type: UIButtonType.system) as UIButton
        btnSlitKReadings.frame = CGRect(x: 0, y: 112, width: 150, height: 30)
        btnSlitKReadings.backgroundColor = UIColor.white
        btnSlitKReadings.titleLabel?.textColor = UIColor.white
        btnSlitKReadings.setTitle("RXLenses", for: UIControlState())
        btnSlitKReadings.addTarget(self, action: #selector(PrescriptionTypeController.btnRXLensesPressed), for: .touchDown)
        
        //btnTrialDetails = UIButton(type: UIButtonType.System) as UIButton
        //btnTrialDetails.frame = CGRectMake(0, 143, 150, 30)
        //btnTrialDetails.backgroundColor = UIColor.whiteColor()
        //btnTrialDetails.titleLabel?.textColor = UIColor.whiteColor()
        //btnTrialDetails.setTitle("TrialDetails", forState: UIControlState.Normal)
        //btnTrialDetails.addTarget(self, action: "btnTrialDetailsPressed", forControlEvents: .TouchDown)
        
        self.view.addSubview(btnRxGlasses)
        self.view.addSubview(btnRxContactLens)
        self.view.addSubview(btnSlitKReadings)
        //self.view.addSubview(btnTrialDetails)
        
        btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PrescriptionTypeController.btnCancelPressed(_:)))
        navigationItem.rightBarButtonItem = btnCancel
    }
    
    func btnTrialDetailsPressed() {
        txtPrescriptionType.text = "TrialDetails"
        lblPrescriptionTypeNumber.text = "TrialDetails No."
        self.dismiss(animated: true, completion: nil)
        txtPrescriptionType.sendActions(for: .editingChanged)
    }
    
    func btnRXLensesPressed() {
        txtPrescriptionType.text = "RXLenses"
        
        self.dismiss(animated: true, completion: nil)
        if fromWorkOrderStatusPage == true {
            
        }else{
            lblPrescriptionTypeNumber.text = "RXGlasses No."
            txtPrescriptionType.sendActions(for: .editingChanged)
        }
    }
    
    func btnStockLensesPressed() {
        txtPrescriptionType.text = "StockLenses"
        
        self.dismiss(animated: true, completion: nil)
        if fromWorkOrderStatusPage == true {
            
        }else{
            lblPrescriptionTypeNumber.text = "RXGlasses No."
            txtPrescriptionType.sendActions(for: .editingChanged)
        }
    }
    
    func btnRxContactLensPressed() {
        txtPrescriptionType.text = "ContactLenses"
        
        self.dismiss(animated: true, completion: nil)
        if fromWorkOrderStatusPage == true {
            
        }else{
            lblPrescriptionTypeNumber.text = "RXContactLens No."
            txtPrescriptionType.sendActions(for: .editingChanged)
        }
    }
    
    func btnCancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
