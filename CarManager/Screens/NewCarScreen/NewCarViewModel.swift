//
//  NewCarViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation

protocol NewCarViewModelProtocol {
    init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol)
}

final class NewCarViewModel: NewCarViewModelProtocol {
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        
    }
}
