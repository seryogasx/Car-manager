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
    
    private let engineTypes = ["ATMO", "TURBO", "HYBRID", "HYDROGEN", "ELECTRIC", "OTHER"]
    private let transmissionTypes = ["MT", "AT", "AMT", "CVT"]
    private let wheelSizes: [Int16] = Array<Int16>(13...23)
    private let antifreezeAges = Array<Int16>(0...2)
    private let brakeFluidAges = Array<Int16>(0...2)
    private let aidKitAges = Array<Int16>(0...4)
    private let extinguisherAge = Array<Int16>(0...10)
    
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
    
    public func saveNewCar(properties: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: mainContext) else { return }
        let newCarManagedObject = NSManagedObject(entity: entity, insertInto: mainContext)
        
        properties.forEach { key, value in
            newCarManagedObject.setValue(value, forKey: key)
        }
        do {
            try mainContext.save()
        } catch {
            print("StorageManager error! Can't save new car!")
        }
    }
    
    public func saveNewNote() {
        
    }
    
    public func editCar() {
        
    }
    
    public func editNote() {
        
    }
    
    public func getCars() -> [Car] {
        return []
    }
    
    
}
