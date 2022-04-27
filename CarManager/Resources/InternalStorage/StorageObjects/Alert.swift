//
//  Alert.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift

class Alert: Object {
    @Persisted var text: String = ""
    @Persisted var completeDate: Date?
    @Persisted var initialDate: Date?
}
