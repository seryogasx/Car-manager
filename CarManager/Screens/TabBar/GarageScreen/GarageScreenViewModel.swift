//
//  MainVCViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 21.03.2022.
//

import Foundation
import CoreData
import RxSwift
import UIKit

protocol GarageScreenViewModelProtocol: AnyObject {
    var cars: PublishSubject<[Car]> { get set }
    var storage: StorageManagerProtocol { get }
    func requestData()
    func getCarLogo(url: URL) -> UIImage
    init(storage: StorageManagerProtocol)
}

class GarageScreenViewModel: NSObject, GarageScreenViewModelProtocol, NSFetchedResultsControllerDelegate {

    var cars: PublishSubject<[Car]> = PublishSubject<[Car]>()
    var storage: StorageManagerProtocol

    func requestData() {
        if let fetchedCars = storage.fetchObjects(objectType: Car.self) as? [Car] {
            cars.onNext(fetchedCars)
        }
    }

    func getCarLogo(url: URL) -> UIImage {
        var logo: UIImage = UIImage(named: "DefaultCarImage")!
        storage.getImage(url: url) { result in
            switch result {
                case .success(let image):
                    logo = image
                case .failure(let error):
                    print("fail to get car logo! \(error.localizedDescription)")
            }
        }
        return logo
    }

//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if controller.managedObjectContext.hasChanges {
//            do {
//                try controller.managedObjectContext.save()
//            } catch {
//                print("Fail to save context!")
//            }
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//        self.getCars()
//    }

    required init(storage: StorageManagerProtocol) {
        self.storage = storage
        super.init()
    }
}
