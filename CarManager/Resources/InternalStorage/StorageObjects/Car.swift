//
//  Car.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift

class Car: Object {
    @Persisted var nickName: String = ""
    @Persisted var mark: String = ""
    @Persisted var model: String = ""
    @Persisted var year: Int = 0
    @Persisted var mileage: Int = 0
    @Persisted var photoURLString: String = ""
    @Persisted var engine: String = ""
    @Persisted var transmissionType: TransmissionType = .none
    @Persisted var tyreSeasonType: TyreSeasonType = .allSeason
    
    @Persisted var alerts: List<Alert>
    @Persisted var notes: List<Note>
}

enum TransmissionType: String, PersistableEnum {
    case amt
    case at
    case mt
    case none
}

enum TyreSeasonType: String, PersistableEnum {
    case allSeason
    case summer
    case winter
}
