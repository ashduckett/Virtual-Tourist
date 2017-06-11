//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 08/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        // Ensure that we add an annotation when the user presses on the map for 1.5 seconds
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        self.navigationItem.backBarButtonItem = backItem
        
        
        
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func something() {
        print("something fired")
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin was tapped at \(view.annotation!.coordinate.latitude) and \(view.annotation!.coordinate.longitude)")
     
        
        // We want to display the other view controller here
        let controller: PhotoAlbumViewController
        controller = (self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController")) as! PhotoAlbumViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
        //self.present(controller, animated: true, completion: nil)
        
        // This line has to run in order to be able to reselect the pin again. Otherwise two taps
        // will only cause the recognition of one
        mapView.deselectAnnotation(view.annotation, animated: false)
    }



}

