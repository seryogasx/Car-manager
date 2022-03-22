//
//  StorageError.swift
//  CarManager
//
//  Created by Сергей Петров on 20.03.2022.
//

import Foundation

enum StorageError: Error {
    case noData(message: String)
    case failToSave(message: String)
    case nothingToSave(message: String)
    case failToFetch(message: String)
    case failToDelete(message: String)
    case unknown(message: String)
}
