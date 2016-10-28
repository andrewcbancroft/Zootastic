import Foundation
import CoreData

public class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedDataStore() {
        seedZoos()
        seedClassifications()
        seedAnimals()
    }
    
    fileprivate func seedZoos() {
        let zoos = [
            (name: "Oklahoma City Zoo", location: "Oklahoma City, OK"),
            (name: "Lowry Park Zoo", location: "Tampa, FL"),
            (name: "San Diego Zoo", location: "San Diego, CA")
        ]
        
        for zoo in zoos {
            let newZoo = NSEntityDescription.insertNewObject(forEntityName: "Zoo", into: context) as! Zoo
            newZoo.name = zoo.name
            newZoo.location = zoo.location
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
    fileprivate func seedClassifications() {
        let classifications = [
            (scientificClassification: "Mammalia", order: "Sirenia", family: "Trichechidae"),
            (scientificClassification: "Mammalia", order: "Primates", family: "Atelidae"),
            (scientificClassification: "Mammalia", order: "Chiroptera", family: "Phyllostomidae")
        ]
        
        for classification in classifications {
            let newClassification = NSEntityDescription.insertNewObject(forEntityName: "Classification", into: context) as! Classification
            newClassification.scientificClassification = classification.scientificClassification
            newClassification.family = classification.family
            newClassification.order = classification.order
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
    fileprivate func seedAnimals() {
        let classificationFetchRequest = NSFetchRequest<Classification>(entityName: "Classification")
        let allClassifications = try! context.fetch(classificationFetchRequest)
        
        let manatee = allClassifications.filter({(c: Classification) -> Bool in
            return c.family == "Trichechidae"
        }).first
        
        let monkey = allClassifications.filter({(c: Classification) -> Bool in
            return c.family == "Atelidae"
        }).first
        
        let bat = allClassifications.filter({(c: Classification) -> Bool in
            return c.family == "Phyllostomidae"
        }).first
        
        
        let zooFetchRequest = NSFetchRequest<Zoo>(entityName: "Zoo")
        let allZoos = try! context.fetch(zooFetchRequest)
        
        let oklahomaCityZoo = allZoos.filter({ (z: Zoo) -> Bool in
            return z.name == "Oklahoma City Zoo"
        }).first
        
        let sanDiegoZoo = allZoos.filter({ (z: Zoo) -> Bool in
            return z.name == "San Diego Zoo"
        }).first
        
        
        let lowryParkZoo = allZoos.filter({ (z: Zoo) -> Bool in
            return z.name == "Lowry Park Zoo"
        }).first
        
        let animals = [
            (commonName: "Pygmy Fruit-eating Bat", habitat: "Flying Mamals Exhibit", classification: bat!, zoos: NSSet(array: [lowryParkZoo!, oklahomaCityZoo!, sanDiegoZoo!])),
            (commonName: "Mantled Howler", habitat: "Primate Exhibit", classification: monkey!, zoos: NSSet(array: [sanDiegoZoo!, lowryParkZoo!])),
            (commonName: "Geoffroy’s Spider Monkey", habitat: "Primate Exhibit", classification: monkey!, zoos: NSSet(array: [sanDiegoZoo!])),
            (commonName: "West Indian Manatee", habitat: "Aquatic Mamals Exhibit", classification: manatee!, zoos: NSSet(array: [lowryParkZoo!]))
        ]
        
        for animal in animals {
            let newAnimal = NSEntityDescription.insertNewObject(forEntityName: "Animal", into: context) as! Animal
            newAnimal.commonName = animal.commonName
            newAnimal.habitat = animal.habitat
            newAnimal.classification = animal.classification
            newAnimal.zoos = animal.zoos
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
    
    public func printAllZoos() {
        let zooFetchRequest = NSFetchRequest<Zoo>(entityName: "Zoo")
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        zooFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allZoos = try! context.fetch(zooFetchRequest)
        
        for zoo in allZoos {
            print("Zoo Name: \(zoo.name)\nLocation: \(zoo.location) \n-------\n", terminator: "")
        }
    }
    
    public func printAllClassifications() {
        let classificationFetchRequest = NSFetchRequest<Classification>(entityName: "Classification")
        let primarySortDescriptor = NSSortDescriptor(key: "family", ascending: true)
        
        classificationFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allClassifications = try! context.fetch(classificationFetchRequest)
        
        for classification in allClassifications {
            print("Scientific Classification: \(classification.scientificClassification)\nOrder: \(classification.order)\nFamily: \(classification.family) \n-------\n", terminator: "")
        }
    }
    
    public func printAllAnimals() {
        let animalFetchRequest = NSFetchRequest<Animal>(entityName: "Animal")
        let primarySortDescriptor = NSSortDescriptor(key: "habitat", ascending: true)
        
        animalFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allAnimals = try! context.fetch(animalFetchRequest)
        
        for animal in allAnimals {
            print("\(animal.commonName), a member of the \(animal.classification.family) family, lives in the \(animal.habitat) at the following zoos:\n", terminator: "")
            for zooElement in animal.zoos {
                if let zoo = zooElement as? Zoo {
                    print("> \(zoo.name)\n", terminator: "")
                }
            }
            print("-------\n", terminator: "")
        }
    }
}
