//
//  NewCarDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol NewCarScreenDIContainerProtocol {
    func getView() -> NewCarViewControllerProtocol
    var viewModel: NewCarViewModelProtocol { get }
    init(storageManager: StorageManagerProtocol,
         networkManager: NetworkManagerProtocol)
}

class NewCarScreenDIContainer: NewCarScreenDIContainerProtocol {
    var viewModel: NewCarViewModelProtocol
    
    func getView() -> NewCarViewControllerProtocol {
        return NewCarViewController(viewModel: viewModel)
    }
    
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        viewModel = NewCarViewModel(storageManager: storageManager, networkManager: networkManager)
    }
}
