//
//  CarDetailsScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol CarDetailsScreenDIContainerProtocol {
    func getView(car: Car) -> CarDetailViewControllerProtocol
    var viewModel: CarDetailsViewModelProtocol { get }
    init(storageManager: StorageManagerProtocol)
}

class CarDetailsScreenDIContainer: CarDetailsScreenDIContainerProtocol {
    
    var viewModel: CarDetailsViewModelProtocol
    
    func getView(car: Car) -> CarDetailViewControllerProtocol {
        return CarDetailsViewController(viewModel: viewModel, car: car)
    }
    
    required init(storageManager: StorageManagerProtocol) {
        viewModel = CarDetailsViewModel(storageManager: storageManager)
    }
}
