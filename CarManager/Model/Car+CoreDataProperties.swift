//
//  Car+CoreDataProperties.swift
//  CarManager
//
//  Created by Сергей Петров on 22.11.2021.
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
