//
//  CarDetailViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import RxSwift

protocol CarDetailsViewModelProtocol {
//    var car: PublishSubject<Car> { get set }
//    var storageManager: StorageManagerProtocol { get set }
    func addNewEmptyNote()
//    init(storageManager: StorageManagerProtocol, car: Car)
}

class CarDetailsViewModel: CarDetailsViewModelProtocol {
//    var car: PublishSubject<Car> = PublishSubject<Car>()
//
//    var storageManager: StorageManagerProtocol
//
    func addNewEmptyNote() {
        let newNote = Note()
    }
//
//    required init(storageManager: StorageManagerProtocol, car: Car) {
//        self.storageManager = storageManager
//        self.car.onNext(car)
//    }
}
