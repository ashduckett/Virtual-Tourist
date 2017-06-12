//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 08/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var photoAlbum: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var managedContext: NSManagedObjectContext!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    
    // This will be set before the view is loaded and will be the pin that was selected.
    var pin: Pin!
    var photos: [Photo]?
    
    var hasAlbum: Bool = false
    
    
    // This method is called each time the view opens
    override func viewDidLoad() {
        super.viewDidLoad()
        photoAlbum.dataSource = self
        photoAlbum.delegate = self
        
        let pinLocation = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        let region = MKCoordinateRegionMake(pinLocation, MKCoordinateSpanMake(0.5, 0.5))
        mapView.setCenter(pinLocation, animated: true)
        mapView.setRegion(region, animated: false)
        
        FlickrAPI.getPhotosForPin(pin: pin, completionHandler: {
            // The pin should now have all of its URLs but not its images
            
            DispatchQueue.global(qos: .background).async {
                if let photos = self.pin.photos {   // Get the current set of photos. These will be in the context
                    for photo in photos {           // Iterate over the photos
                        let item = photo as! Photo
                        
                        guard let urString = item.imageURL else {
                            return
                        }
                        
                        guard let url = URL(string: urString) else {
                            return
                        }
                        
                        // If the data has nothing in it, load the data based on the url.
                        if item.imageData == nil {
                            if let imageData = try? Data(contentsOf: url) {
                                item.imageData = imageData as NSData
                                
                                DispatchQueue.main.async {
                                    self.photoAlbum.reloadData()
                                }
                            }
                        }
                    }
                    
                    do {
                        try self.managedContext.save()
                    } catch {
                        print("badness")
                    }
                }
                print("All necessary data downloaded for current pin.")
            }
            print("Async code still running.")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let newCollectionButton = UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(newCollection))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        setToolbarItems([flexibleSpace, newCollectionButton, flexibleSpace], animated: true)
    
        }
    
    private func flickrURLFromParameters(_ parameters: [String: String]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    func newCollection() {
        print("New Collection button hit")
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            let result = try managedContext.execute(request)
        } catch {
            print("prob")
        }
        
        let fetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let request1 = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            let result2 = try managedContext.execute(request1)
        } catch {
            print("prob")
        }
    }
}

extension PhotoAlbumViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! PhotoAlbumCell
        
        cell.backgroundColor = UIColor.black
        
        let photo = pin.photos?[indexPath.item] as! Photo
        
        // If it has associated data, load it
        if let photoImage = photo.imageData {
            cell.imageView.image = UIImage(data: photoImage as Data)
        // If not, display a placeholder
        } else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
        
       
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let photoCount = pin.photos?.count else {
            return 0
        }
        
        return photoCount
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (CGFloat(3) + 1.0)
        let availableWidth = photoAlbum.frame.width - paddingSpace

        let widthPerItem = availableWidth / 3.0
        
        return CGSize(width: widthPerItem, height: widthPerItem)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
