//
//  MainScreenAdapter.swift
//  CarManager
//
//  Created by Сергей Петров on 20.03.2022.
//

import Foundation
import CoreData
import Combine

protocol MainScreenAdapterProtocol: AnyObject {
    var carGateway: CarStorageGatewayProtocol { get set }
    var viewModel: MainScreenViewModelProtocol? { get set }
    func fetchCars(completion: @escaping (Result<[Car], StorageError>) -> Void)
}

class MainScreenAdapter: NSObject, MainScreenAdapterProtocol {
    var carGateway: CarStorageGatewayProtocol
    
    weak var viewModel: MainScreenViewModelProtocol?
    
    func fetchCars(completion: @escaping (Result<[Car], StorageError>) -> Void) {
        carGateway.fetchCars { result in
            switch result {
                case .success(let controller):
                    controller.delegate = self
                    completion(.success(controller.fetchedObjects ?? []))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    init(carGateway: CarStorageGatewayProtocol) {
        self.carGateway = carGateway
    }
}

extension MainScreenAdapter: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        viewModel?.getCars()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller.managedObjectContext.hasChanges {
            do {
                try controller.managedObjectContext.save()
                print("Success auto save context!")
            } catch {
                print("Fail to auto save context!")
            }
        }
    }
}
