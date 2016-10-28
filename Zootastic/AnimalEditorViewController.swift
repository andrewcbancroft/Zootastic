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
        let fetchRequest = NSFetchRequest<Classification>(entityName: "Classification")
        
        do {
            let classifications = try context.fetch(fetchRequest)
            return classifications
        } catch {}
        
        return []
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classifications.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let classification = classifications[row]
        let title = "\(classification.family) - \(classification.order)"
        return title
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let newAnimal = NSEntityDescription.insertNewObject(forEntityName: "Animal", into: context) as! Animal
        
        if let commonNameText = commonNameTextField.text {
            newAnimal.commonName = commonNameText
        }
        
        if let habitatText = habitatTextField.text {
            newAnimal.habitat = habitatText
        }
        
        let selectedClassification = classifications[classificationPickerView.selectedRow(inComponent: 0)]
        newAnimal.classification = selectedClassification
        
        do {
            try context.save()
        } catch {}
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
