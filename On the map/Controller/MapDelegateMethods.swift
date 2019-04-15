//
//  MapDelegateMethods.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/15/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import MapKit

extension MapVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView=mapView.dequeueReusableAnnotationView(withIdentifier: "pinView") as? MKPinAnnotationView
        if pinView==nil{
            pinView=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView?.canShowCallout=true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.pinTintColor = .purple
            print("entered")
        }
        else{
            pinView?.annotation=annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let application=UIApplication.shared
        application.open(URL(string: view.annotation!.subtitle! ?? "")!, options: [:], completionHandler: nil)
        print("clicked")
    }
}
