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
    var long:Double!
    var lat:Double!
    var mapUrl:String!
    @IBOutlet weak var mapView: MKMapView!
    var newRegion:MKCoordinateRegion!
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate=self
        displayResultLocation(locationName: self.locationName)
    }
    
    func displayResultLocation(locationName:String){
        if let newRegion=newRegion{
            self.lat=newRegion.center.latitude
            self.long=newRegion.center.longitude
            let annotation=MKPointAnnotation()
            annotation.coordinate=newRegion.center
            annotation.title=self.locationName
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(newRegion, animated: true)
        }
        else{
            ErrorHandler.showError(vc: self, message: "Cannot find the desired location, please try again later", title: "Error finding the location")
            }
            
        
    }
    
    @IBAction func finishAddingLocation(_ sender: Any) {
        let newLocation=StudentLocation.init(mapString: locationName, mapUrl: mapUrl, latitude: lat, longitude: long)
        Client.postStudentLocation(location: newLocation, completionHandler: handleAddingLocation(success:error:))
        
    }
    
    func handleAddingLocation(success:Bool,error:Error?){
        if error != nil || !success{
            DispatchQueue.main.async {
                ErrorHandler.showError(vc: self, message: "Cannot add location, please try again later", title: "Cannot add new location")
            }
            return
        }
        if success{
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
