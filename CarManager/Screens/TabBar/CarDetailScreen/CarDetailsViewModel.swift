//
//  CarDetailViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import RxSwift

protocol CarDetailsViewModelProtocol {
    var carSubject: PublishSubject<Car> { get set }
    var car: Car? { get set }
    var storage: StorageManagerProtocol { get set }
    func addNewEmptyNote()
    init(storageManager: StorageManagerProtocol)
}

class CarDetailsViewModel: CarDetailsViewModelProtocol {
    
    var carSubject: PublishSubject<Car> = PublishSubject<Car>()
    var car: Car? {
        didSet {
            if let car = car {
                carSubject.onNext(car)
            }
        }
    }

    var storage: StorageManagerProtocol

    func addNewEmptyNote() {
        print(#function)
        let newNote = Note()
        storage.updateObjects {
            car?.notes.append(newNote)
        }
    }

    required init(storageManager: StorageManagerProtocol) {
        self.storage = storageManager
    }
}
