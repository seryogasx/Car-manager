//
//  MainVCViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 21.03.2022.
//

import Foundation
import CoreData
import RxSwift

protocol GarageScreenViewModelProtocol: AnyObject {
//    var carsPublisher: PublishSubject<[Car]> { get set }
    var cars: PublishSubject<[Car]> { get set }
    var storage: StorageManagerProtocol { get }
    func getCars()
    init(storage: StorageManagerProtocol)
}

class GarageScreenViewModel: NSObject, GarageScreenViewModelProtocol, NSFetchedResultsControllerDelegate {
    
//    var carsPublisher: PublishSubject<[Car]> = PublishSubject<[Car]>()
    var cars: PublishSubject<[Car]> = PublishSubject<[Car]>()
    var storage: StorageManagerProtocol {
        didSet {
            getCars()
        }
    }
    
    func getCars() {
        if let fetchedCars = storage.fetchObjects(objectType: Car.self) as? [Car] {
            cars.onNext(fetchedCars)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller.managedObjectContext.hasChanges {
            do {
                try controller.managedObjectContext.save()
            } catch {
                print("Fail to save context!")
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.getCars()
    }
    
    required init(storage: StorageManagerProtocol) {
        self.storage = storage
        super.init()
    }
}
