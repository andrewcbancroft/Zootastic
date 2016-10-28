//
//  ZootasticTests.swift
//  ZootasticTests
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import UIKit
import XCTest
import CoreData
import Zootastic

class ZootasticTests: XCTestCase {
	func testSeedZoosInserts3ZooObjectsIntoDataStore() {
		// arrange
		let context = setUpInMemoryManagedObjectContext()
		let dataHelper = DataHelper(context: context)
		
		// act
		dataHelper.seedZoos()
		
		// assert
		let fetchRequest = NSFetchRequest<Zoo>(entityName: "Zoo")
		do {
			let zoos = try context.fetch(fetchRequest)
			XCTAssertTrue(zoos.count == 3, "There should have been 3 Zoo objects inserted by seedZoos()")
		} catch _ {}
	}
}

// See http://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
// for more information on this helper function

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
	let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
	
	let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
	try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
	
	let managedObjectContext = NSManagedObjectContext()
	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
	
	return managedObjectContext
}
