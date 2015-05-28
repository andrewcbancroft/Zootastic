//
//  AnimalEditorViewController.swift
//  Zootastic
//
//  Created by Andrew Bancroft on 5/27/15.
//  Copyright (c) 2015 Andrew Bancroft. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class AnimalEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	@IBOutlet weak var commonNameTextField: UITextField!
	@IBOutlet weak var habitatTextField: UITextField!
	@IBOutlet weak var classificationPickerView: UIPickerView!
	
	var context: NSManagedObjectContext!
	var classifications: [Classification]!
	
	public override func viewDidLoad() {
		self.classifications = fetchClassifications()
	}
	
	func fetchClassifications() -> [Classification] {
		let fetchRequest = NSFetchRequest(entityName: "Classification")
		let classifications = context.executeFetchRequest(fetchRequest, error: nil) as! [Classification]
		
		return classifications
	}
	
	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return classifications.count
	}
	
	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		let classification = classifications[row]
		let title = "\(classification.family) - \(classification.order)"
		return title
	}
	
	@IBAction func saveButtonTapped(sender: UIBarButtonItem) {
		let newAnimal = NSEntityDescription.insertNewObjectForEntityForName("Animal", inManagedObjectContext: context) as! Animal
		newAnimal.commonName = commonNameTextField.text
		newAnimal.habitat = habitatTextField.text
		
		let selectedClassification = classifications[classificationPickerView.selectedRowInComponent(0)]
		newAnimal.classification = selectedClassification
		
		context.save(nil)
		
		self.navigationController?.popViewControllerAnimated(true)
	}
}