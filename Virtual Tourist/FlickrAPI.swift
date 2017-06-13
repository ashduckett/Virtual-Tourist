//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 10/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import CoreData

class FlickrAPI {
    
    static func getPhotosForPin(pin: Pin, completionHandler: @escaping () -> Void) {
        
        let methodParameters: [String:String] = [
            Constants.FlickrParameterKeys.BoundingBox:bboxString(pin: pin),
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        FlickrAPIClient.performFlickrGETRequest(urlToHit: flickrURLFromParameters(methodParameters), completionHandler: {(success, errorString, result, response) in
            
            if success {
                
                guard let result = result else {
                    return
                }
                
                guard let photosDictionary = result[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                    return
                }
                
                guard let photosArray = photosDictionary["photo"] as! [AnyObject]? else {
                    return
                }
                                
                if (pin.photos?.count)! == 0 {
                    
                    for photo in photosArray {
                        let photoToAdd = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: pin.managedObjectContext!) as! Photo
                    
                        if let photoURL = photo["url_m"] as! String? {
                            photoToAdd.imageURL = photoURL
                        }
                    
                        pin.addToPhotos(photoToAdd)
                    
                    }
                }
                completionHandler()
                
                
            } else {
                completionHandler()
            }
        })
    }
    
    
    private static func flickrURLFromParameters(_ parameters: [String: String]) -> URL {
        
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

    
    private static func bboxString(pin: Pin) -> String {
        
        let longitude = pin.longitude
        let latitude = pin.latitude
        
        let minimumLongitude = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLatitude = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
         
        let maximumLongitude = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLatitude = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.1)
         
        return "\(minimumLongitude), \(minimumLatitude), \(maximumLongitude), \(maximumLatitude)"
    }

}
