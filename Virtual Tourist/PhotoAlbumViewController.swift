//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 08/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var photoAlbum: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoAlbum.dataSource = self
        photoAlbum.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let newCollectionButton = UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(newCollection))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        setToolbarItems([flexibleSpace, newCollectionButton, flexibleSpace], animated: true)
    
    
    
    
    
        FlickrAPI.getPhotoCountForSearch(completionHandler: {(errorString, result) in
            print("We have a total of \(result!)")
            
            // At this point we can populate the CollectionView based on the value of result.
            // This will just be the placeholder.
            
            // How do we set up the placeholders?
            
        
        })
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
    
    private func bboxString() -> String {
        // There are constants named SearchBBoxHalfWidth (lng) and SearchBBoxHalfHeight (lat)
        
        // Also ensure that the lat range falls in between SearchLatRange (-90, 90) and lng (-180, 180)
        
        // Could we have got a 2000 for a minimum value?
        /*if let latitude = Double(latitudeTextField.text!), let longitude = Double(longitudeTextField.text!) {
            let minimumLongitude = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let minimumLatitude = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            
            
            
            let maximumLongitude = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maximumLatitude = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.1)
            
            
            print("\(minimumLongitude), \(minimumLatitude), \(maximumLongitude), \(maximumLatitude)")
            
            //return "\(minimumLongitude), \(minimumLatitude), \(maximumLongitude), \(maximumLatitude)"
            
            // Return a dummy result for now
            return "74.4, 73.5, 76.4, 75.5"
        } else {
            return "0,0,0,0"
        }*/
        
        // Dummy result
        return "74.4, 73.5, 76.4, 75.5"
    }
    
    func newCollection() {
        print("New Collection button hit")
    }
}

extension PhotoAlbumViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath)
        
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (CGFloat(3) + 1.0)
        let availableWidth = photoAlbum.frame.width - paddingSpace
        
        //let availableWidth = 100.0//collectionView.frame.width
        let widthPerItem = availableWidth / 3.0
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        //return CGSize(width: availableWidth / 2, height: availableWidth / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      
        print("Called")

        

        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
