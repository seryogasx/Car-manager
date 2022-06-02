//
//  AppDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol AppDIContainerProtocol {
    var rootViewController: MainViewControllerProtocol { get }
    var storageManager: StorageManagerProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
    var locationManager: LocationManagerProtocol { get }
    var notificationManager: NotificationManagerProtocol { get }
    var mainScreenDIContainer: MainScreenDIContainerProtocol { get }
}

class AppDIContainer: AppDIContainerProtocol {
    var rootViewController: MainViewControllerProtocol
    var storageManager: StorageManagerProtocol = StorageManager.shared
    var networkManager: NetworkManagerProtocol = NetworkManager.shared
    var locationManager: LocationManagerProtocol = LocationManager.shared
    var notificationManager: NotificationManagerProtocol = NotificationManager.shared
    var mainScreenDIContainer: MainScreenDIContainerProtocol

    init() {
        mainScreenDIContainer = MainScreenDIContainer(storageManager: storageManager,
                                                      locationManager: locationManager,
                                                      networkManager: networkManager,
                                                      notificationManager: notificationManager)
        rootViewController = MainViewController(mainScreenDIContainer: mainScreenDIContainer)
    }
}
