//
//  NewLocationMapDelegate.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/19/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import MapKit
import UIKit
extension NewLocationMapVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinView") as? MKPinAnnotationView
        if pinView==nil{
            pinView=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinView")
            pinView?.canShowCallout=true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.tintColor = .red
            
        }
        
        else{
            pinView?.annotation=annotation
        }
        
        return pinView
    }
    
    
}
