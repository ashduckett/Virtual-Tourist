//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 08/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        // Ensure that we add an annotation when the user presses on the map for 1.5 seconds
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPress)
    }
    
    func addAnnotation(gestureRecogniser: UIGestureRecognizer) {
        if gestureRecogniser.state == .began {
            let touchPoint = gestureRecogniser.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
        }
    }
    
    // I use this to describe the look of each annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .purple
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }



}

