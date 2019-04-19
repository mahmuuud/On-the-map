//
//  AddLocationVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit

class AddLocationVC: UIViewController {
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var url: UITextField!

    @IBAction func findLocation(_ sender: Any) {
        if self.locationName.text != ""{
            self.performSegue(withIdentifier: "geocode", sender: self)
        }
        else{
            ErrorHandler.showError(vc: self, message: "Please enter a right location", title: "Cannot search for this location")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! NewLocationMapVC
        if self.locationName.text != ""{
            vc.locationName=self.locationName.text!
            vc.mapUrl=url.text ?? ""
        }
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
