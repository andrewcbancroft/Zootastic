//
//  ViewController.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import UIKit
import CoreData

public class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	
	public var context: NSManagedObjectContext!
	
	lazy var fetchedResultsController: NSFetchedResultsController = {
		let animalsFetchRequest = NSFetchRequest(entityName: "Animal")
		let primarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
		let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
		animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
		
		let frc = NSFetchedResultsController(
			fetchRequest: animalsFetchRequest,
			managedObjectContext: self.context,
			sectionNameKeyPath: "classification.order",
			cacheName: nil)
		
		frc.delegate = self
		
		return frc
		}()
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		var error: NSError? = nil
		if (fetchedResultsController.performFetch(&error) == false) {
			print("An error occurred: \(error?.localizedDescription)")
		}
	}
	
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: TableView Data Source
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections.count
		}
		
		return 0
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section] as! NSFetchedResultsSectionInfo
			return currentSection.numberOfObjects
		}
		
		return 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		let animal = fetchedResultsController.objectAtIndexPath(indexPath) as! Animal
		
		cell.textLabel?.text = animal.commonName
		cell.detailTextLabel?.text = animal.habitat
		
		return cell
	}
	
	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section] as! NSFetchedResultsSectionInfo
			return currentSection.name
		}
		
		return nil
	}
}

