//
//  StorageError.swift
//  CarManager
//
//  Created by Сергей Петров on 22.04.2022.
//

import Foundation

enum StorageError: Error {
    case noData(message: String)
    case internalError(message: String)
}
