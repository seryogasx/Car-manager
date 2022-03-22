//
//  AlertGateway.swift
//  CarManager
//
//  Created by Сергей Петров on 19.03.2022.
//

import Foundation
import CoreData

protocol AlertStorageGatewayProtocol: CoreDataGateway {
    typealias AlertFetchedResultsController = NSFetchedResultsController<Alert>
    var alertFetchedResultsController: AlertFetchedResultsController { get }
    func fetchAlerts(car: Car, completion: @escaping (Result<AlertFetchedResultsController, StorageError>) -> Void)
    func deleteAlert(alert: Alert, completion: @escaping (StorageError?) -> Void)
    func addAlert(alert: Alert, completion: @escaping (StorageError?) -> Void)
    func initAlert(car: Car) -> Alert
}

class AlertGateway: AlertStorageGatewayProtocol {
    
    var storageManager: StorageManagerProtocol
    
    lazy var alertFetchedResultsController: AlertFetchedResultsController = {
        let context = storageManager.mainContext
        let fetchRequest = Alert.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let controller = AlertFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: context,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        return controller
    }()
    
    func fetchAlerts(car: Car, completion: @escaping (Result<AlertFetchedResultsController, StorageError>) -> Void) {
        do {
            try alertFetchedResultsController.performFetch()
            completion(.success(alertFetchedResultsController))
        } catch let error {
            completion(.failure(StorageError.failToFetch(message: "Fail to fetch alerts! \(error.localizedDescription)")))
        }
    }
    
    func deleteAlert(alert: Alert, completion: @escaping (StorageError?) -> Void) {
        let context = storageManager.mainContext
        context.delete(alert)
        storageManager.saveContext(context: context) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func initAlert(car: Car) -> Alert {
        let alert = Alert(entity: Alert.entity(), insertInto: storageManager.mainContext)
        alert.car = car
        return alert
    }
    
    func addAlert(alert: Alert, completion: @escaping (StorageError?) -> Void) {
        if let carContext = alert.managedObjectContext {
            storageManager.saveContext(context: carContext) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(StorageError.noData(message: "No context for aler! Please, use initAlert!"))
        }
    }
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
}
