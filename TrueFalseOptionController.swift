//
//  TrueFalseOptionControllerViewController.swift
//  TouchymPOS
//
//  Created by XCodeClub on 2016-05-11.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class TrueFalseOptionController: UIViewController {

    var selectedDate : UITextField!
    var parentView: UIViewController!
    
    var buttonMale : UIButton!
    var buttonFemale : UIButton!
    var buttonCncel : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonMale = UIButton(type: UIButtonType.system) as UIButton
        buttonMale.frame = CGRect(x: 0, y: 50, width: 100, height: 30)
        buttonMale.backgroundColor = UIColor.white
        buttonMale.titleLabel?.textColor = UIColor.white
        buttonMale.setTitle("Male", for: UIControlState())
        buttonMale.addTarget(self, action: #selector(TrueFalseOptionController.buttonMalePressed), for: .touchDown)

        buttonFemale = UIButton(type: UIButtonType.system) as UIButton
        buttonFemale.frame = CGRect(x: 101, y: 50, width: 100, height: 30)
        buttonFemale.backgroundColor = UIColor.white
        buttonFemale.titleLabel?.textColor = UIColor.white
        buttonFemale.setTitle("Female", for: UIControlState())
        buttonFemale.addTarget(self, action: #selector(TrueFalseOptionController.buttonFemalePressed), for: .touchDown)
        
        self.view.addSubview(buttonMale)
        self.view.addSubview(buttonFemale)
        
        buttonCncel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TrueFalseOptionController.buttonCancelPressed(_:)))
        navigationItem.rightBarButtonItem = buttonCncel
    }
    
    func buttonMalePressed() {
        selectedDate.text = "Male"
        self.dismiss(animated: true, completion: nil)
    }
    func buttonFemalePressed() {
        selectedDate.text = "Female"
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonCancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
