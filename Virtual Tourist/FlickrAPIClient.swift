//
//  FlickrAPIClient.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 10/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation

class FlickrAPIClient {
    // Function for a GET request
    static func performFlickrGETRequest(urlToHit: URL, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ results: [String:AnyObject]?, _ response: URLResponse?) -> Void) {
        // You will want to pass in a closure using the data field to return any data obtained
        
        let session = URLSession.shared
        
        // Should possibly validate url here
        let request = URLRequest(url: urlToHit)
        var parsedResult: [String:AnyObject]
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                print(error)
            }
            
            
            guard(error == nil) else {
                completionHandler(false, "There was an error with your request", nil, response)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(false, "Your request returned a status code other than 2xx", nil, response)
                return
            }
            
            guard let data = data else {
                completionHandler(false, "No data returned.", nil, response)
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError(error: "Oh no!")
                return
            }
            
            // Do nothing specific here, but call a completionHandler and pass to it the errors/data/response
            // When you call this completion handler, you can define what you want to do with the data.
            // This completion handler will probably be called from the convenience file, but test it from the
            // viewDidLoad method first.
            
            /*guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Problemo")
                return
            }
            
            guard let total = photosDictionary["total"] as? String else {
                print("Problem")
                return
            }
            
            // This works now
            print(total)*/
            
            // Call the completion handler with success and results
            completionHandler(true, nil, parsedResult, response)
            
            
        }
        
        
        
        
        //print("Total: \(total)")
        
        task.resume()
    }
}
