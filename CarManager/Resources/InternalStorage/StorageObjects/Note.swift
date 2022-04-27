//
//  Note.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift

class Note: Object {
    @Persisted var text: String = ""
    @Persisted var completeDate: Date?
}
