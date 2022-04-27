//
//  StatisticsScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol StatisticsScreenDIContainerProtocol {
    var view: StatisticsViewControllerProtocol { get }
    var viewModel: StatisticsViewModelProtocol { get }
    init(storageManager: StorageManagerProtocol)
}

class StatisticsScreenDIContainer: StatisticsScreenDIContainerProtocol {
    var view: StatisticsViewControllerProtocol
    var viewModel: StatisticsViewModelProtocol
    
    required init(storageManager: StorageManagerProtocol) {
        viewModel = StatisticsViewModel()
        view = StatisticsViewController(viewModel: viewModel)
    }
}
