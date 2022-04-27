//
//  MainVCViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 21.03.2022.
//

import Foundation
import CoreData

protocol GarageScreenViewModelProtocol: AnyObject {
    var carsPublisher: Published<[Car]>.Publisher { get }
    var storage: StorageManagerProtocol { get }
    func getCars()
    init(storage: StorageManagerProtocol)
}

class GarageScreenViewModel: NSObject, GarageScreenViewModelProtocol, NSFetchedResultsControllerDelegate {
    
    @Published var cars: [Car] = []
    var carsPublisher: Published<[Car]>.Publisher { $cars }
    var storage: StorageManagerProtocol {
        didSet {
            getCars()
        }
    }
    
    func getCars() {
        cars = storage.fetchObjects(objectType: Car.self)?.reduce(into: []) { partialResult, item in
            if let car = item as? Car {
                partialResult?.append(car)
            }
        } ?? []
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
