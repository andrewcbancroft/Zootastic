//
//  ViewController.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 2/23/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

// blah blah

import UIKit
import CoreData

public class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate {
	
	public var context: NSManagedObjectContext!
	@IBOutlet weak var tableView: UITableView!
	
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
	
	// MARK: TableView Delegate
	public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			let animal = fetchedResultsController.objectAtIndexPath(indexPath) as! Animal
			confirmDeleteForAnimal(animal)
		}
	}
	
	var animalToDelete: Animal?
	
	func confirmDeleteForAnimal(animal: Animal) {
		self.animalToDelete = animal
		let confirmDeleteActionSheet = UIActionSheet(title: "Are you sure you want to permanently delete \(animal.commonName)?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete")
		confirmDeleteActionSheet.showInView(self.view)
	}
	
	// MARK: UIActionSheetDelegate methods
	public func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		if buttonIndex == 0 {
			deleteAnimal()
		} else {
			self.animalToDelete = nil
		}
	}
	
	func deleteAnimal() {
		if let verseToDelete = self.animalToDelete {
			self.context.deleteObject(verseToDelete)
			self.context.save(nil)
			self.animalToDelete = nil
		}
	}
	
	// MARK: NSFetchedResultsControllerDelegate methods
	public func controllerWillChangeContent(controller: NSFetchedResultsController) {
		self.tableView.beginUpdates()
	}
	
	public func controller(
		controller: NSFetchedResultsController,
		didChangeObject anObject: AnyObject,
		atIndexPath indexPath: NSIndexPath?,
		forChangeType type: NSFetchedResultsChangeType,
		newIndexPath: NSIndexPath?) {
			
			switch type {
			case NSFetchedResultsChangeType.Insert:
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				}
			case NSFetchedResultsChangeType.Delete:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				}
			case NSFetchedResultsChangeType.Update:
				if let updateIndexPath = indexPath {
					let cell = self.tableView.cellForRowAtIndexPath(updateIndexPath)
					let animal = self.fetchedResultsController.objectAtIndexPath(updateIndexPath) as? Animal
					
					cell?.textLabel?.text = animal?.commonName
					cell?.detailTextLabel?.text = animal?.habitat
				}
			case NSFetchedResultsChangeType.Move:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				}
				
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				}
			}
	}
	
	public func controller(
		controller: NSFetchedResultsController,
		didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
		atIndex sectionIndex: Int,
		forChangeType type: NSFetchedResultsChangeType) {
		
			switch type {
			case .Insert:
				let sectionIndexSet = NSIndexSet(index: sectionIndex)
				self.tableView.insertSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
			case .Delete:
				let sectionIndexSet = NSIndexSet(index: sectionIndex)
				self.tableView.deleteSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
			default:
				""
			}
	}
	
	public func controller(controller: NSFetchedResultsController, sectionIndexTitleForSectionName sectionName: String?) -> String? {
		return sectionName
	}
	
	public func controllerDidChangeContent(controller: NSFetchedResultsController) {
		self.tableView.endUpdates()
	}
	
	// MARK: Navigation
	public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == SegueIdentifiers.AnimalEditorSegue.rawValue {
			let destination = segue.destinationViewController as! AnimalEditorViewController
			destination.context = self.context
		}
	}
}

