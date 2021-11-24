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
    
    private func saveContext(errorMessage: String, context: NSManagedObjectContext) -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                print(errorMessage)
            }
        }
        return false
    }
    
    public func updateStorage() -> Bool {
        return saveContext(errorMessage: "StorageManager error! Can't update storage!", context: mainContext)
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
    
    public func initNewCar() -> Car {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: mainContext) else {
            return Car()
        }
        return Car(entity: entity, insertInto: mainContext)
    }
    
    public func saveNewCar(car: Car) -> Bool {
        return saveContext(errorMessage: "Can't save new car!", context: mainContext)
    }
    
    public func saveNewCar(properties: [String: Any]) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: mainContext) else { return false }
        let car = Car(entity: entity, insertInto: mainContext)
        
//        car.setValuesForKeys(properties)
        
        car.photoURL = properties["photoURL"] as? String
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
        
        guard let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: mainContext) else { return false }
        
        for i in 0...2 {
            let note = Note(entity: noteEntity, insertInto: mainContext)
            note.text = "note\(i)"
            note.isAlert = false
            note.isComplete = false
            car.addToNotes(note)
            
        }
        for i in 0...2 {
            let note = Note(entity: noteEntity, insertInto: mainContext)
            note.text = "alert\(i)"
            note.isAlert = true
            note.isComplete = false
            car.addToNotes(note)
            
        }
        
        return saveContext(errorMessage: "StorageManager error! Can't save new car!", context: mainContext)
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
        note.isAlert = false
        note.isComplete = false
        return note
    }
    
    public func createNewAlert(alertText: String = "") -> Note? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: mainContext) else { return nil }
        let note = Note(entity: entity, insertInto: mainContext)
        note.isAlert = true
        note.isComplete = false
        note.text = alertText
        return note
    }
    
    public func deleteNote(note: Note) -> Bool {
        mainContext.delete(note)
        return saveContext(errorMessage: "StorageManager error! Can't delete object in storage!", context: mainContext)
    }
}


extension Car: Identifiable {
    static var paramTypes: [(String, Int)] {
        return [("Photo", 1), ("Input", 5), ("Select", 8), ("Bool", 12)]
    }
    
    static var propertyTypes: [(String, [String])] {
        return [("Identity", getIdentityProperties()), ("Main", getMainProperties()), ("Additional", getAdditionalProperties())]
    }
    
    static func getIdentityProperties() -> [String] {
        return ["nickName", "photoURL"]
    }
    
    static func getMainProperties() -> [String] {
        return ["mark", "model", "year", "mileage"]
    }
    
    static func getAdditionalProperties() -> [String] {
        var items: [String] = ["engineType", "transmissionType", "tireType", "wheelsSize"]
//        items.append("antifreezeAge")
//        items.append("brakeFluidAge")
//        items.append("extinguisherAge")
//        items.append("aidKitAge")
        return items
    }
    
    static func getBoolProperties() -> [String] {
        return ["reflectiveVestExists", "warningTriangleExists", "scraperExists", "brainageBasinExists", "compressorExists",
                "startingWiresExists", "ragsExists", "videoRecorderExists", "fusesExists", "spareWheelExists",
                "jackExists", "spannersExists"]
    }
    
    static var propertiesCount: Int {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: StorageManager.shared.mainContext) else { return 0 }
        let someCar = Car(entity: entity, insertInto: StorageManager.shared.mainContext)
        return someCar.entity.attributesByName.count
    }
    
    static var paramNames: [String] {
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: StorageManager.shared.mainContext) else { return [] }
        let someCar = Car(entity: entity, insertInto: StorageManager.shared.mainContext)
        let arr = someCar.entity.attributesByName.enumerated().map { $0.element.key }
        return arr
    }
    
    static func getOptionsForProperty(propertyName: String) -> [String] {
        if !getAdditionalProperties().contains(propertyName) { return [] }
        switch propertyName {
            case "engineType":
                return ["Turbocharged", "Atmospheric", "Hybrid", "Electric", "Hydrogen"]
            case "transmissionType":
                return ["MT", "AT", "AMT", "CVT", "Other"]
            case "wheelsSize":
                return (14...26).map { String(describing: $0) }
            case "tireType":
                return ["summer", "winter"]
//            case "antifreezeAge":
//                return ["<1 year", "<2 year", ">2 year"]
//            case "brakeFluidAge":
//                return ["<1 year", "<2 year", "<3 year", ">3 year"]
//            case "extinguisherAge":
//                return ["<1 year", "<2 year", "<3 year", ">3 year"]
//            case "aidKitAge":
//                return ["<1 year", "<2 year", "<3 year", ">3 year"]
            default:
                return []
        }
    }
    
    static func getHintForProperty(property: String) -> String {
        switch property {
            case "aidKitAge":
                return "Аптечка"
            case "antifreezeAge":
                return "Замена антифриза"
            case "brainageBasinExists":
                return "Водосгон"
            case "brakeFluidAge":
                return "Замена тормозной жидкости"
            case "compressorExists":
                return "Компрессор или насос"
            case "engineType":
                return "Укажите тип двигателя"
            case "extinguisherAge":
                return "Срок огнетушителя"
            case "fusesExists":
                return "Запасные предохранители"
            case "jackExists":
                return "Домкрат"
            case "mark":
                return "Укажите марку авто"
            case "mileage":
                return "Укажите пробег"
            case "model":
                return "Укажите модель авто"
            case "nickName":
                return "Укажите псевдоним авто"
            case "photoURL":
                return "Укажите иконку авто"
            case "ragsExists":
                return "Тряпки для сушки авто?"
            case "reflectiveVestExists":
                return "Светоотражающий жилет"
            case "scraperExists":
                return "Скребок"
            case "spannersExists":
                return "Гаечные ключи"
            case "spareWheelExists":
                return "Запасное колесо"
            case "startingWiresExists":
                return "Пусковые провода"
            case "tireType":
                return "Укажите тип резины"
            case "transmissionType":
                return "Укажите тип трансмиссии"
            case "videoRecorderExists":
                return "Видеорегистратор"
            case "warningTriangleExists":
                return "Знак аварийной остановки"
            case "wheelsSize":
                return "Укажите размер колес"
            case "year":
                return "Укажите год выпуска авто"
            default:
//                print(property)
                return ""
        }
    }
}
