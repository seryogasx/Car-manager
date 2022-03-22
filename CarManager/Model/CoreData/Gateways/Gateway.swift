//
//  Gateway.swift
//  CarManager
//
//  Created by Сергей Петров on 20.03.2022.
//

import Foundation

protocol CoreDataGateway {
    var storageManager: StorageManagerProtocol { get }
}
