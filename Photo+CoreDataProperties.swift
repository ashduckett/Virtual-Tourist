//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 12/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var pin: Pin?

}
