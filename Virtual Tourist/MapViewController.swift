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
        
        // When the view loads, we need to get hold of all the pins and plonk them on the map
        do {
            let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
            
            let pins = try managedContext.fetch(fetchRequest)
          
            for pin in pins {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = pin.latitude
                annotation.coordinate.longitude = pin.longitude
                mapView.addAnnotation(annotation)
            }
        } catch let error as NSError {
            print("Problem fetching pins \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
  
    
    func addAnnotation(gestureRecogniser: UIGestureRecognizer) {
        if gestureRecogniser.state == .began {
            let touchPoint = gestureRecogniser.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
           
            let entity = NSEntityDescription.entity(forEntityName: "Pin", in: managedContext)!
            
            let pin = Pin(entity: entity, insertInto: managedContext)
            
            pin.latitude = annotation.coordinate.latitude
            pin.longitude = annotation.coordinate.longitude
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Saving went badly. Awww, no. \(error)")
            }

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
        
        // Here you'll need to fetch your pin. This will be done by lat long. You can then set the pin on the controller.
        
        // First make sure you can get hold of the pin. Do a query, then check for a result of 1.
        let lat = view.annotation?.coordinate.latitude
        let lng = view.annotation?.coordinate.longitude
        
        print(" Clicked lat = \(lat!) lng = \(lng!)")
        
        //let pinPredicate = NSPredicate(format: "(latitude == \(lat!)) AND (longitude == \(lng!))")
        
        let firstPredicate = NSPredicate(format: "latitude == %lf", lat!)
        let secondPredicate = NSPredicate(format: "longitude == %lf", lng!)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [firstPredicate, secondPredicate])
        
        
        
        var pins = [Pin]()
        
        do {
            let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
            fetchRequest.predicate = predicate
            pins = try managedContext.fetch(fetchRequest)
        } catch {
            print("Error getting pin to show photographs for.")
            return
        }
        
        let controller: PhotoAlbumViewController
        
        controller = (self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController")) as! PhotoAlbumViewController
        
        controller.managedContext = self.managedContext
        controller.pin = pins.first
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        // This line has to run in order to be able to reselect the pin again. Otherwise two taps
        // will only cause the recognition of one
        mapView.deselectAnnotation(view.annotation, animated: false)
    }



}

