//
//  NewCarDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol NewCarScreenDIContainerProtocol {
    var view: NewCarViewControllerProtocol { get }
    var viewModel: NewCarViewModelProtocol { get }
    init(storageManager: StorageManagerProtocol,
         networkManager: NetworkManagerProtocol)
}

class NewCarScreenDIContainer: NewCarScreenDIContainerProtocol {
    var view: NewCarViewControllerProtocol
    var viewModel: NewCarViewModelProtocol
    
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        viewModel = NewCarViewModel(storageManager: storageManager, networkManager: networkManager)
        view = NewCarViewController(viewModel: viewModel)
    }
}
