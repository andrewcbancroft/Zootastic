//
//  Zoo.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import Foundation
import CoreData

public class Zoo: NSManagedObject {

    @NSManaged var location: String
    @NSManaged var name: String
    @NSManaged var animals: NSSet

}
