//
//  NewLocationMapVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationMapVC: UIViewController {
    var locationName:String=""
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayResultLocation(locationName: self.locationName)
        mapView.delegate=self
    
    }
    
    func displayResultLocation(locationName:String){
        let geocoder =  CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            if error != nil || placemarks==nil{
                ErrorHandler.showError(vc: self, message: "Cannot find the desired location, please try again later", title: "Error finding the location")
                return
            }
            let location=placemarks![0].location
            if let coordinate=location?.coordinate{
                let region=MKCoordinateRegion(center: coordinate , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                let annotation=MKPointAnnotation()
                annotation.coordinate=coordinate
                annotation.title=placemarks![0].name!
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(region, animated: true)
            }
            else{
                 ErrorHandler.showError(vc: self, message: "Cannot find the desired location, please try again later", title: "Error finding the location")
            }
            
        }
    }
    
    @IBAction func finishAddingLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
