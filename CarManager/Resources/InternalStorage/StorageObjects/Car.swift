//
//  Car.swift
//  CarManager
//
//  Created by Сергей Петров on 21.04.2022.
//

import Foundation
import RealmSwift

class Car: Object {
    @Persisted var photoURLString: String = ""
    // identifying properties
    @Persisted var nickName: String = ""
    // main info properties
    @Persisted var mark: String = ""
    @Persisted var model: String = ""
    @Persisted var year: Int = 0
    // details properties
    @Persisted var engine: String = ""
    @Persisted var transmissionType: TransmissionType = .none
    @Persisted var mileage: Int = 0
    @Persisted var tyreSeasonType: TyreSeasonType = .allSeason

    @Persisted var alerts: List<Alert> = .init()
    @Persisted var notes: List<Note> = .init()
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
