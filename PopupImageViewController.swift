//
//  PopupImageViewController.swift
//  TouchymPOS
//
//  Created by ESHACK on 8/19/17.
//  Copyright © 2017 aljaber. All rights reserved.
//

import UIKit

class PopupImageViewController: UIViewController,UIPopoverPresentationControllerDelegate  {

    var buttonCncel : UIBarButtonItem!
    var parentView: UIViewController!
    var imageName: String = ""
    var adminModel = AdminSettingModel.getInstance()
    var lblImage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = String(adminModel.serverUrl)
        if (url?.contains("api/"))! {
            let endIndex = url?.index((url?.endIndex)!, offsetBy: -4)
            url = url?.substring(to: endIndex!)
        }
        var folder = "UploadedFiles/"
        url = url! + folder + imageName as String?
        if let checkedUrl = URL(string: url!) {
            getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? checkedUrl.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    self.lblImage = UILabel(frame: CGRect(x: 0, y: 20, width: 800, height: 600))
                    self.lblImage.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
                    self.view.addSubview(self.lblImage)
                    
                }
            }
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
