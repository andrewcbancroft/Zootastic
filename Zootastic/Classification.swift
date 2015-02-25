//
//  Classification.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import Foundation
import CoreData

public class Classification: NSManagedObject {

    @NSManaged var scientificClassification: String
	@NSManaged var family: String
	@NSManaged var order: String
    @NSManaged var animals: NSSet

}
