//
//  Note+CoreDataProperties.swift
//  CarManager
//
//  Created by Сергей Петров on 22.11.2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var isComplete: Bool
    @NSManaged public var text: String?
    @NSManaged public var isAlert: Bool
    @NSManaged public var car: Car?

}
