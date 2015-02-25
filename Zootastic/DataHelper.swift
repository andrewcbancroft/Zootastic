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
	
	private func seedZoos() {
		let zoos = [
			(name: "San Diego Zoo", location: "San Diego, CA"),
			(name: "Lowry Park Zoo", location: "Tampa, FL"),
			(name: "Oklahoma City Zoo", location: "Oklahoma City, OK")
		]
		
		for zoo in zoos {
			let newZoo = NSEntityDescription.insertNewObjectForEntityForName("Zoo", inManagedObjectContext: context) as Zoo
			newZoo.name = zoo.name
			newZoo.location = zoo.location
		}
		
		context.save(nil)
	}
	
	private func seedClassifications() {
		let classifications = [
			(scientificClassification: "Mammalia", order: "Sirenia", family: "Trichechidae"),
			(scientificClassification: "Mammalia", order: "Primates", family: "Atelidae"),
			(scientificClassification: "Mammalia", order: "Chiroptera", family: "Phyllostomidae")
		]
		
		for classification in classifications {
			let newClassification = NSEntityDescription.insertNewObjectForEntityForName("Classification", inManagedObjectContext: context) as Classification
			newClassification.scientificClassification = classification.scientificClassification
			newClassification.family = classification.family
			newClassification.order = classification.order
		}
		
		context.save(nil)
	}
	
	private func seedAnimals() {
		let classificationFetchRequest = NSFetchRequest(entityName: "Classification")
		let allClassifications = context.executeFetchRequest(classificationFetchRequest, error: nil) as [Classification]

		let manatee = allClassifications.filter({(c: Classification) -> Bool in
			return c.family == "Trichechidae"
		}).first
		
		let monkey = allClassifications.filter({(c: Classification) -> Bool in
			return c.family == "Atelidae"
		}).first
		
		let bat = allClassifications.filter({(c: Classification) -> Bool in
			return c.family == "Phyllostomidae"
		}).first
		
		
		let zooFetchRequest = NSFetchRequest(entityName: "Zoo")
		let allZoos = context.executeFetchRequest(zooFetchRequest, error: nil) as [Zoo]
		
		let sanDiegoZoo = allZoos.filter({ (z: Zoo) -> Bool in
			return z.name == "San Diego Zoo"
		}).first
		
		let oklahomaCityZoo = allZoos.filter({ (z: Zoo) -> Bool in
			return z.name == "Oklahoma City Zoo"
		}).first
		
		let lowryParkZoo = allZoos.filter({ (z: Zoo) -> Bool in
			return z.name == "Lowry Park Zoo"
		}).first
		
		let animals = [
			(commonName: "Pygmy Fruit-eating Bat", habitat: "Flying Mamals Exhibit", classification: bat, zoos: NSSet(array: [lowryParkZoo!, oklahomaCityZoo!, sanDiegoZoo!])),
			(commonName: "Mantled Howler", habitat: "Primate Exhibit", classification: monkey, zoos: NSSet(array: [sanDiegoZoo!, lowryParkZoo!])),
			(commonName: "Geoffroy’s Spider Monkey", habitat: "Primate Exhibit", classification: monkey, zoos: NSSet(array: [sanDiegoZoo!])),
			(commonName: "West Indian Manatee", habitat: "Aquatic Mamals Exhibit", classification: manatee, zoos: NSSet(array: [lowryParkZoo!]))
		]
		
		for animal in animals {
			let newAnimal = NSEntityDescription.insertNewObjectForEntityForName("Animal", inManagedObjectContext: context) as Animal
			newAnimal.commonName = animal.commonName
			newAnimal.habitat = animal.habitat
			newAnimal.classification = animal.classification!
			newAnimal.zoos = animal.zoos
		}
		
		context.save(nil)
	}
	
	
	public func printAllZoos() {
		let zooFetchRequest = NSFetchRequest(entityName: "Zoo")
		let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		
		zooFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allZoos = context.executeFetchRequest(zooFetchRequest, error: nil) as [Zoo]
		
		for zoo in allZoos {
			print("Zoo Name: \(zoo.name)\nLocation: \(zoo.location) \n-------\n")
		}
	}
	
	public func printAllClassifications() {
		let classificationFetchRequest = NSFetchRequest(entityName: "Classification")
		let primarySortDescriptor = NSSortDescriptor(key: "family", ascending: true)
		
		classificationFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allClassifications = context.executeFetchRequest(classificationFetchRequest, error: nil) as [Classification]
		
		for classification in allClassifications {
			print("Scientific Classification: \(classification.scientificClassification)\nOrder: \(classification.order)\nFamily: \(classification.family) \n-------\n")
		}
	}
	
	public func printAllAnimals() {
		let animalFetchRequest = NSFetchRequest(entityName: "Animal")
		let primarySortDescriptor = NSSortDescriptor(key: "habitat", ascending: true)
		
		animalFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allAnimals = context.executeFetchRequest(animalFetchRequest, error: nil) as [Animal]
		
		for animal in allAnimals {
			print("\(animal.commonName), a member of the \(animal.classification.family) family, lives in the \(animal.habitat) at the following zoos:\n")
			for zoo in animal.zoos {
				print("> \(zoo.name)\n")
			}
			print("-------\n")
		}
	}
}