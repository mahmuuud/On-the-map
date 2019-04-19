//
//  TabBarVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        Client.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        Client.getStudentLocations { (locations, error) in
            if error != nil {
                ErrorHandler.showError(vc: self, message: "Please check your internet connection", title: "Error refreshing locations")
                return
            }
            (self.viewControllers![0] as! MapVC).handleLocationResponse(locations: locations, error: error)
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        Client.getAccountLocation { (exists, error) in
            DispatchQueue.main.async {
            if error != nil || exists==nil{
                ErrorHandler.showError(vc: self, message: "Cannot fetch account Location, please try again", title: "Error")
                return
            }
            else if exists!{
                let alert=UIAlertController(title: "Location Exists ", message: "A location exists for this account, would you like to overwrite it?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {action in self.performSegue(withIdentifier: "addLocation", sender: self)}))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert,animated: true,completion: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "addLocation", sender: self)
                }
            }
        }
    }
    
}
