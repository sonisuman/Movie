//
//  Movie+CoreDataProperties.swift
//  Movie
//
//  Created by Andi Setiyadi on 6/7/18.
//  Copyright © 2018 devhubs. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var format: String?
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var userRating: Int16

}
