//
//  CarDetailsScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol CarDetailsScreenDIContainerProtocol {
    var view: CarDetailViewControllerProtocol { get }
    var viewModel: CarDetailsViewModelProtocol { get }
    init(storageManager: StorageManagerProtocol)
}

class CarDetailsScreenDIContainer: CarDetailsScreenDIContainerProtocol {
    var view: CarDetailViewControllerProtocol
    var viewModel: CarDetailsViewModelProtocol
    
    required init(storageManager: StorageManagerProtocol) {
        viewModel = CarDetailsViewModel()
        view = CarDetailsViewController(viewModel: viewModel)
    }
}
