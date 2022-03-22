//
//  MainVCViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 21.03.2022.
//

import Foundation
import CoreData

protocol MainScreenViewModelProtocol: AnyObject {
    var carsPublisher: Published<[Car]>.Publisher { get }
    var adapter: MainScreenAdapterProtocol { get }
    func getCars()
}

class MainScreenViewModel: NSObject, MainScreenViewModelProtocol, NSFetchedResultsControllerDelegate {
    
    @Published var cars: [Car] = []
    var carsPublisher: Published<[Car]>.Publisher { $cars }
    var adapter: MainScreenAdapterProtocol
    
    func getCars() {
        adapter.fetchCars { [weak self] result in
            switch result {
                case .success(let cars):
                    self?.cars = cars
                case .failure(let error):
                    print(error.localizedDescription)
            }
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
    
    init(adapter: MainScreenAdapterProtocol) {
        self.adapter = adapter
        super.init()
        self.adapter.viewModel = self
        getCars()
    }
}
