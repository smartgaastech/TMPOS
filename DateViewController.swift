//
//  DateViewController.swift
//  TouchymPOS
//
//  Created by user115796 on 4/25/16.
//  Copyright © 2016 aljaber. All rights reserved.
//

import UIKit

class DateViewController: UIViewController,UIPopoverPresentationControllerDelegate  {
    
   
    
    var datePicker: UIDatePicker!
    var buttonToday: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    var buttonCncel : UIBarButtonItem!
    var dateFormatter = DateFormatter()
    var selectedDate : UITextField!
    var parentView: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 300))
        datePicker.datePickerMode = .date
        self.view.addSubview(datePicker)
        buttonToday = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.done, target: self, action: #selector(DateViewController.buttonTodayPressed(_:)))
        buttonToday.title = "Today"
        navigationItem.leftBarButtonItem = buttonToday
        buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DateViewController.buttonDonePressed(_:)))
        buttonCncel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DateViewController.buttonCancelPressed(_:)))
        navigationItem.rightBarButtonItems = [buttonCncel,buttonDone]
    }
    
    func buttonTodayPressed(_ sender : AnyObject) {
        datePicker.date = Date()
        let strDate = dateFormatter.string(from: datePicker.date)
        self.selectedDate.text = strDate
        self.dismiss(animated: true, completion: nil)
        
    }
    func buttonDonePressed(_ sender: AnyObject) {
        let strDate = dateFormatter.string(from: datePicker.date)
        self.selectedDate.text = strDate
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonCancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }    
}
