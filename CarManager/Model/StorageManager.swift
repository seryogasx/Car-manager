//
//  StorageManager.swift
//  CarManager
//
//  Created by Сергей Петров on 29.10.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    static var shared = StorageManager()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
//    var backgroundContext: NSManagedObjectContext {
//        return persistentContainer.newBackgroundContext()
//    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
    
    private init() {  }
    
    private func saveContext(errorMessage: String, context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(errorMessage)
        }
    }
    
    public func updateStorage() {
        saveContext(errorMessage: "StorageManager error! Can't update storage!", context: mainContext)
    }
}

// MARK: Car functions
extension StorageManager {
    
    public func getCars() -> [Car] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        var cars: [Car] = []
        do {
            let result = try mainContext.fetch(fetchRequest)
            for data in result {
                if let car = data as? Car {
                    cars.append(car)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return cars
    }
    
    public func saveNewCar(properties: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: mainContext) else { return }
        let car = Car(entity: entity, insertInto: mainContext)
        
        car.setValuesForKeys(properties)
        
//        car.photoURL = properties["photo"] as? String
//        car.nickName = "octaha"
//        car.mark = "skoda"
//        car.model = "octavia"
//        car.year = 2018
//        car.mileage = 94000
//        car.engineType = "turbo"
//        car.transmissionType = "amt"
//        car.wheelsSize = 18
//        car.tireType = "summer"
//        car.antifreezeAge = 2
//        car.brakeFluidAge = 2
//        car.aidKitAge = 0
//        car.extinguisherAge = 0
//        car.reflectiveVestExists = true
//        car.warningTriangleExists = true
//        car.scraperExists = true
//        car.brainageBasinExists = true
//        car.compressorExists = true
//        car.startingWiresExists = true
//        car.ragsExists = true
//        car.videoRecorderExists = true
//        car.fusesExists = true
//        car.spannersExists = true
//        car.jackExists = true
//        car.spannersExists = true
        
        guard let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: mainContext) else { return }
        
        for i in 0...3 {
            let note = Note(entity: noteEntity, insertInto: mainContext)
            note.text = "kek\(i)"
            car.addToNotes(note)
        }
        
        saveContext(errorMessage: "StorageManager error! Can't save new car!", context: mainContext)
    }
    
    public func carsWithTires(tiresType: CarInputData.TireTypes) -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        var carsNickNames: [String] = []
        do {
            let result = try mainContext.fetch(fetchRequest)
            for data in result {
                if let car = data as? Car {
                    if car.tireType == (tiresType == .winter ? "winter" : "summer") {
                        carsNickNames.append(car.nickName ?? car.mark ?? car.model ?? "UNKNOWN")
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return carsNickNames
    }
}

// MARK: Note functions
extension StorageManager {
    
    public func createNewNote() -> Note? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: mainContext) else { return nil }
        let note = Note(entity: entity, insertInto: mainContext)
        return note
    }
    
    public func deleteNote(note: Note) {
        mainContext.delete(note)
        saveContext(errorMessage: "StorageManager error! Can't delete object in storage!", context: mainContext)
    }
}
