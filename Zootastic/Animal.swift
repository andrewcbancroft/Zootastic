//
//  Animal.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import Foundation
import CoreData

public class Animal: NSManagedObject {
	
	@NSManaged var habitat: String
	@NSManaged var commonName: String
	@NSManaged var classification: Classification
	@NSManaged var zoos: NSSet
	
}