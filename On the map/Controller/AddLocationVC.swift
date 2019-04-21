//
//  AddLocationVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var newRegion:MKCoordinateRegion?
    
    override func viewDidLoad() {
        locationName.delegate=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
    }

    @IBAction func findLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        if  locationName.text! != ""{
            getResultRegion(locationName: locationName.text!)
            self.activityIndicator.stopAnimating()
            
        }
        else if self.locationName.text!==""{
            ErrorHandler.showError(vc: self, message: "Please enter a right location", title: "Cannot search for this location")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! NewLocationMapVC
        if let newRegion=self.newRegion{
            vc.newRegion=newRegion
            vc.locationName=locationName.text!
            vc.mapUrl=url.text!
        }
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getResultRegion(locationName:String){
        let geocoder =  CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            if error != nil || placemarks==nil{
                self.activityIndicator.stopAnimating()
                ErrorHandler.showError(vc: self, message: "Cannot find the desired location, please try again later", title: "Error finding the location")
                return
            }
            let location=placemarks![0].location
            if let coordinate=location?.coordinate{
                let region=MKCoordinateRegion(center: coordinate , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                DispatchQueue.main.async {
                    self.newRegion=region
                    self.performSegue(withIdentifier: "geocode", sender: self)
                }
            }
            else{
                self.activityIndicator.stopAnimating()
                ErrorHandler.showError(vc: self, message: "Cannot find the desired location, please try again later", title: "Error finding the location")
                return
            }
            
        }
    }
    
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
