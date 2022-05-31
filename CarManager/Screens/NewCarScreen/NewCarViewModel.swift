//
//  NewCarViewModel.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit
import RxSwift

protocol NewCarViewModelProtocol {
    var storageManager: StorageManagerProtocol { get set }
    var networkManager: NetworkManagerProtocol { get set }
    var car: Car { get set }
    var carLogoImage: UIImage? { get set }
    func addCar(completion: (Result<String, StorageError>) -> Void)
    init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol)
}

final class NewCarViewModel: NewCarViewModelProtocol {
    
    var storageManager: StorageManagerProtocol
    var networkManager: NetworkManagerProtocol
    
    var car: Car = Car()
    var carLogoImage: UIImage?
    
    func addCar(completion: (Result<String, StorageError>) -> Void) {
        print("Add car! \(car)")
        if checkCarData() {
            if let photo = carLogoImage {
                car.photoURLString = storageManager.saveImage(image: photo)?.absoluteString ?? ""
            }
            storageManager.addObject(object: car) { error in
                if let error = error {
                    completion(.failure(StorageError.noData(message: "Ошибка добавления авто! \(error.localizedDescription)")))
                } else {
                    completion(.success("Авто добавлено в гараж!"))
                }
            }
        }
    }
    
    private func checkCarData() -> Bool {
        if let _ = self.car.nickName {
            return true
        }
        return false
    }
    
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.storageManager = storageManager
        self.networkManager = networkManager
    }
}
