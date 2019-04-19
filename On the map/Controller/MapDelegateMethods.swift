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
        }
            
        else{
            pinView?.annotation=annotation
        }
        self.mapView.reloadInputViews()
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let application=UIApplication.shared
        var url:URL?=nil
        if let subtitle=view.annotation?.subtitle!{
            url=URL(string: subtitle)
        }
        if let url=url{
            if application.canOpenURL(url){
                application.open(url, options: [:], completionHandler: nil)
            }
            else{
                ErrorHandler.showError(vc: self, message: "The location URL is not a valid one", title: "Cannot open URL")
            }
        }
        else if url==nil{
            ErrorHandler.showError(vc: self, message: "The location URL is not a valid one", title: "Cannot open URL")
        }
    }
}
