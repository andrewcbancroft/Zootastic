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
	
	open var context: NSManagedObjectContext!
	
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
}

