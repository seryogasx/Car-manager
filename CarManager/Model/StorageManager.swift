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
        
        var car = Car(entity: entity, insertInto: mainContext)
        
        car.photoURL = ""
        car.nickName = "octaha"
        car.mark = "skoda"
        car.model = "octavia"
        car.year = 2018
        car.mileage = 94000
        car.engineType = "turbo"
        car.transmissionType = "amt"
        car.wheelsSize = 18
        car.tireType = "summer"
        car.antifreezeAge = 2
        car.brakeFluidAge = 2
        car.aidKitAge = 0
        car.extinguisherAge = 0
        car.reflectiveVestExists = true
        car.warningTriangleExists = true
        car.scraperExists = true
        car.brainageBasinExists = true
        car.compressorExists = true
        car.startingWiresExists = true
        car.ragsExists = true
        car.videoRecorderExists = true
        car.fusesExists = true
        car.spannersExists = true
        car.jackExists = true
        car.spannersExists = true
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
    
    
}
