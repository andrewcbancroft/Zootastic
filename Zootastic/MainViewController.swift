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
	
	open var context: NSManagedObjectContext!
	@IBOutlet weak var tableView: UITableView!
	
    var fetchedResultsController: NSFetchedResultsController<Animal>!

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
        
    }
    
    func configureFetchedResultsController() {
        let animalsFetchRequest = NSFetchRequest<Animal>(entityName: "Animal")
        let primarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        
        self.fetchedResultsController = NSFetchedResultsController<Animal>(
            fetchRequest: animalsFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: "classification.order",
            cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
    }
    
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: TableView Data Source
	public func numberOfSections(in tableView: UITableView) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections.count
		}
		
		return 0
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section] 
			return currentSection.numberOfObjects
		}
		
		return 0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
		let animal = fetchedResultsController.object(at: indexPath) 
		
		cell.textLabel?.text = animal.commonName
		cell.detailTextLabel?.text = animal.habitat
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section] 
			return currentSection.name
		}
		
		return nil
	}
	
	// MARK: TableView Delegate
	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete {
			let animal = fetchedResultsController.object(at: indexPath) 
			confirmDeleteForAnimal(animal)
		}
	}
	
	var animalToDelete: Animal?
	
	func confirmDeleteForAnimal(_ animal: Animal) {
		self.animalToDelete = animal
		let confirmDeleteActionSheet = UIActionSheet(title: "Are you sure you want to permanently delete \(animal.commonName)?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete")
		confirmDeleteActionSheet.show(in: self.view)
	}
	
	// MARK: UIActionSheetDelegate methods
	public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
		if buttonIndex == 0 {
			deleteAnimal()
		} else {
			self.animalToDelete = nil
		}
	}
	
	func deleteAnimal() {
		if let verseToDelete = self.animalToDelete {
			self.context.delete(verseToDelete)
            do {
                try self.context.save()
            } catch {
            }
            
			self.animalToDelete = nil
		}
	}
	
	// MARK: NSFetchedResultsControllerDelegate methods
	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.beginUpdates()
	}
	
	public func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath: IndexPath?) {
			
			switch type {
			case NSFetchedResultsChangeType.insert:
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
				}
			case NSFetchedResultsChangeType.delete:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
				}
			case NSFetchedResultsChangeType.update:
				if let updateIndexPath = indexPath {
					let cell = self.tableView.cellForRow(at: updateIndexPath)
					let animal = self.fetchedResultsController.object(at: updateIndexPath)
					
					cell?.textLabel?.text = animal.commonName
					cell?.detailTextLabel?.text = animal.habitat
				}
			case NSFetchedResultsChangeType.move:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
				}
				
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
				}
			}
	}
	
	public func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange sectionInfo: NSFetchedResultsSectionInfo,
		atSectionIndex sectionIndex: Int,
		for type: NSFetchedResultsChangeType) {
		
			switch type {
			case .insert:
				let sectionIndexSet = IndexSet(integer: sectionIndex)
				self.tableView.insertSections(sectionIndexSet, with: UITableViewRowAnimation.fade)
			case .delete:
				let sectionIndexSet = IndexSet(integer: sectionIndex)
				self.tableView.deleteSections(sectionIndexSet, with: UITableViewRowAnimation.fade)
			default:
                break
			}
	}
	
	public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return sectionName
	}
	
	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
	}
	
	// MARK: Navigation
	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.AnimalEditorSegue.rawValue {
			let destination = segue.destination as! AnimalEditorViewController
			destination.context = self.context
		}
	}
}

