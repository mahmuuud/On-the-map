//
//  MapVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/15/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class MapVC:UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    var annotations:[MKPointAnnotation]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate=self
        Client.getStudentLocations(completionHandler: handleLocationResponse(locations:error:))
           
    }
    
    func handleLocationResponse(locations:[StudentLocation]?,error:Error?){
        if error != nil || locations==nil {
            DispatchQueue.main.async {
                ErrorHandler.showError(vc: self, message: "Error loading locations, please check your connection", title: "Error")
                return
                }
            }
        if let locations=locations{
            LocationsModel.locations=locations
        }
        
        
        for location in LocationsModel.locations{
                if location.firstName==nil || location.lastName==nil || location.longitude==nil || location.latitude==nil || location.mediaUrl==nil{
                    continue
                }
                let lat=CLLocationDegrees(location.latitude!)
                let long=CLLocationDegrees(location.longitude!)
                let coordinates=CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation=MKPointAnnotation()
                annotation.coordinate=coordinates
                annotation.title="\(location.firstName!)  \(String(describing: location.lastName!))"
                annotation.subtitle=location.mediaUrl!
                self.annotations.append(annotation)
            }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
            }
            
        }
    
}
