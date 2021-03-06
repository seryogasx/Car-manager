//
//  StatisticsViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import RxSwift

protocol StatisticsViewModelProtocol {
    var carSubject: PublishSubject<[Car]> { get set }
    var storage: StorageManagerProtocol { get set }
    func requestData()
    init(storageManager: StorageManagerProtocol)
}

final class StatisticsViewModel: StatisticsViewModelProtocol {

    var carSubject: PublishSubject<[Car]> = PublishSubject<[Car]>()
    var storage: StorageManagerProtocol {
        didSet {
            requestData()
        }
    }

    func requestData() {
        if let fetchedCars = storage.fetchObjects(objectType: Car.self) as? [Car] {
            carSubject.onNext(fetchedCars)
        }
    }

    init(storageManager: StorageManagerProtocol) {
        self.storage = storageManager
    }
}
