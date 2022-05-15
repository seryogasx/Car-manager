//
//  NewCarViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol NewCarViewModelProtocol {
    var storageManager: StorageManagerProtocol { get set }
    var networkManager: NetworkManagerProtocol { get set }
    var car: Car { get set }
    init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol)
}

final class NewCarViewModel: NewCarViewModelProtocol {
    
    var storageManager: StorageManagerProtocol
    var networkManager: NetworkManagerProtocol
    
    var car: Car = Car()
    
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.storageManager = storageManager
        self.networkManager = networkManager
    }
}
