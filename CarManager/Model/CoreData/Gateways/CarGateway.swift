//
//  CarGateway.swift
//  CarManager
//
//  Created by Сергей Петров on 19.03.2022.
//

import Foundation
import CoreData

protocol CarStorageGatewayProtocol: CoreDataGateway {
    typealias CarFetchedResultsController = NSFetchedResultsController<Car>
    var carFetchedResultsController: CarFetchedResultsController { get }
    func fetchCars(completion: @escaping (Result<CarFetchedResultsController, StorageError>) -> Void)
    func deleteCars(completion: @escaping (StorageError?) -> Void)
    func deleteCar(car: Car, completion: @escaping (StorageError?) -> Void)
    func addCar(car: Car, completion: @escaping (StorageError?) -> Void)
    func initNewCar() -> Car
}

class CarStorageCateway: CarStorageGatewayProtocol {
    
    var storageManager: StorageManagerProtocol
    
    lazy var carFetchedResultsController: CarFetchedResultsController = {
        let context = storageManager.mainContext
        let fetchRequest = Car.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickName", ascending: true)]
        let controller = CarFetchedResultsController(fetchRequest: fetchRequest,
                                                     managedObjectContext: context,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
        return controller
    }()
    
    func fetchCars(completion: @escaping (Result<CarFetchedResultsController, StorageError>) -> Void) {
        do {
            try carFetchedResultsController.performFetch()
            completion(.success(carFetchedResultsController))
        } catch let error {
            completion(.failure(StorageError.failToFetch(message: "Fail to fetch cars! \(error.localizedDescription)")))
        }
    }
    
    func deleteCars(completion: @escaping (StorageError?) -> Void) {
        fetchCars { result in
            switch result {
                case .success(let controller):
                    controller.fetchedObjects?.forEach { controller.managedObjectContext.delete($0) }
                    self.storageManager.saveContext(context: controller.managedObjectContext) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                case .failure(let error):
                    completion(StorageError.failToDelete(message: "Fail to delete cars! \(error)"))
            }
        }
    }
    
    func deleteCar(car: Car, completion: @escaping (StorageError?) -> Void) {
        let context = storageManager.mainContext
        context.delete(car)
        storageManager.saveContext(context: context) { error in
            if let error = error {
                switch error {
                    case .failToSave(_):
                        completion(error)
                    case .nothingToSave(_):
                        completion(StorageError.noData(message: "No car for delete!"))
                    default:
                        completion(error)
                }
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func initNewCar() -> Car {
        return Car(entity: Car.entity(), insertInto: storageManager.mainContext)
    }
    
    func addCar(car: Car, completion: @escaping (StorageError?) -> Void) {
        if let carContext = car.managedObjectContext {
            storageManager.saveContext(context: carContext) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(StorageError.noData(message: "No context for car! Please, use initNewCar!"))
        }
    }
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
}
