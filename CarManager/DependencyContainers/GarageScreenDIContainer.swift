//
//  GarageScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
// import Swinject
import UIKit

protocol GarageScreenDIContainerProtocol {
    var view: GarageViewControllerProtocol { get }
    var viewModel: GarageScreenViewModelProtocol { get }
    var carDetailsDIContainer: CarDetailsScreenDIContainerProtocol { get }
    var newCarScreenDIContainer: NewCarScreenDIContainerProtocol { get }
    init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol)
}

class GarageScreenDIContainer: GarageScreenDIContainerProtocol {

    var view: GarageViewControllerProtocol
    var viewModel: GarageScreenViewModelProtocol
    var carDetailsDIContainer: CarDetailsScreenDIContainerProtocol
    var newCarScreenDIContainer: NewCarScreenDIContainerProtocol

    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.viewModel = GarageScreenViewModel(storage: storageManager)
        self.carDetailsDIContainer = CarDetailsScreenDIContainer(storageManager: storageManager)
        self.newCarScreenDIContainer = NewCarScreenDIContainer(storageManager: storageManager,
                                                               networkManager: networkManager)
        self.view = GarageViewController(viewModel: viewModel,
                                         newCarDIContainer: newCarScreenDIContainer,
                                         carDetailsDIContainer: carDetailsDIContainer)
    }
}
