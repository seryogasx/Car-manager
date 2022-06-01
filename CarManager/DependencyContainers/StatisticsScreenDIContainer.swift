//
//  StatisticsScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol StatisticsScreenDIContainerProtocol {
    var viewModel: StatisticsViewModelProtocol { get }
    func getView() -> StatisticsViewControllerProtocol
    init(storageManager: StorageManagerProtocol)
}

class StatisticsScreenDIContainer: StatisticsScreenDIContainerProtocol {
    var viewModel: StatisticsViewModelProtocol
    
    func getView() -> StatisticsViewControllerProtocol {
        return StatisticsViewController(viewModel: viewModel)
    }
    
    required init(storageManager: StorageManagerProtocol) {
        viewModel = StatisticsViewModel(storageManager: storageManager)
    }
}
