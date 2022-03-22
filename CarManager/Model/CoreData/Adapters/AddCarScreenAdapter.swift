//
//  AddCarScreenAdapter.swift
//  CarManager
//
//  Created by Сергей Петров on 21.03.2022.
//

import Foundation
import CoreData
import Combine

protocol AddCarScreenAdapterProtocol: AnyObject {
    var carGateway: CarStorageGatewayProtocol { get set }
    func initCar() -> Car
    func saveCar(car: Car, completion: @escaping (StorageError?) -> Void)
}

class AddCarScreenAdapter: NSObject, AddCarScreenAdapterProtocol {
    
    var carGateway: CarStorageGatewayProtocol
    weak var viewModel: AddCarScreenAdapterProtocol?
    
    func initCar() -> Car {
        return self.carGateway.initNewCar()
    }
    
    func saveCar(car: Car, completion: @escaping (StorageError?) -> Void) {
        // FIXME: ADD car data validation!!!
        self.carGateway.addCar(car: car) { error in
            completion(error)
        }
    }
    
    init(carGateway: CarStorageGatewayProtocol) {
        self.carGateway = carGateway
    }
}

//extension AddCarScreenAdapter: NSFetchedResultsControllerDelegate {
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if controller.managedObjectContext.hasChanges {
//            do {
//                try controller.managedObjectContext.save()
//            } catch {
//                print("failed to save context")
//            }
//        }
//    }
//}
