//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 10/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation

class FlickrAPI {
    static func getPhotoCountForSearch(completionHandler: @escaping (_: String?, _: Int?) -> Void) {
        
        
        let methodParameters: [String:String] = [
            Constants.FlickrParameterKeys.BoundingBox:bboxString(),
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        // Here we should be getting the total number of results using a method from the convenience class
        
        FlickrAPIClient.performFlickrGETRequest(urlToHit: flickrURLFromParameters(methodParameters), completionHandler: {(success, errorString, result, response) in
            
            if success {
                // If we've got to this point then we want to find the count
                
                guard let result = result else {
                    return
                }
                
                
                guard let photosDictionary = result[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                    return
                }
                
                //completionHandler(nil, photosDictionary["total"] as? String)
                
                
                guard let total = photosDictionary["total"] as? String else {
                    return
                }
                
                print("Total \(total)")
                completionHandler(nil, Int(total))
                
                
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

    
    private static func bboxString() -> String {
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

}
