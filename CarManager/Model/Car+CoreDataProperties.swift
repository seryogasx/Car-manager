//
//  Car+CoreDataProperties.swift
//  CarManager
//
//  Created by Сергей Петров on 18.11.2021.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var aidKitAge: Int16
    @NSManaged public var antifreezeAge: Int16
    @NSManaged public var brainageBasinExists: Bool
    @NSManaged public var brakeFluidAge: Int16
    @NSManaged public var compressorExists: Bool
    @NSManaged public var engineType: String?
    @NSManaged public var extinguisherAge: Int16
    @NSManaged public var fusesExists: Bool
    @NSManaged public var jackExists: Bool
    @NSManaged public var mark: String?
    @NSManaged public var mileage: Int32
    @NSManaged public var model: String?
    @NSManaged public var nickName: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var ragsExists: Bool
    @NSManaged public var reflectiveVestExists: Bool
    @NSManaged public var scraperExists: Bool
    @NSManaged public var spannersExists: Bool
    @NSManaged public var spareWheelExists: Bool
    @NSManaged public var startingWiresExists: Bool
    @NSManaged public var tireType: String?
    @NSManaged public var transmissionType: String?
    @NSManaged public var videoRecorderExists: Bool
    @NSManaged public var warningTriangleExists: Bool
    @NSManaged public var wheelsSize: Int16
    @NSManaged public var year: Int16
    @NSManaged public var notes: NSOrderedSet?

}

// MARK: Generated accessors for notes
extension Car {

    @objc(insertObject:inNotesAtIndex:)
    @NSManaged public func insertIntoNotes(_ value: Note, at idx: Int)

    @objc(removeObjectFromNotesAtIndex:)
    @NSManaged public func removeFromNotes(at idx: Int)

    @objc(insertNotes:atIndexes:)
    @NSManaged public func insertIntoNotes(_ values: [Note], at indexes: NSIndexSet)

    @objc(removeNotesAtIndexes:)
    @NSManaged public func removeFromNotes(at indexes: NSIndexSet)

    @objc(replaceObjectInNotesAtIndex:withObject:)
    @NSManaged public func replaceNotes(at idx: Int, with value: Note)

    @objc(replaceNotesAtIndexes:withNotes:)
    @NSManaged public func replaceNotes(at indexes: NSIndexSet, with values: [Note])

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSOrderedSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSOrderedSet)

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
        return ["engineType", "transmissionType", "wheelsSize", "tireType", "antifreezeAge", "brakeFluidAge",
                "extinguisherAge", "aidKitAge"]
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
