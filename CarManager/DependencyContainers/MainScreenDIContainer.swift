//
//  MainScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation

protocol MainScreenDIContainerProtocol {
    var locationManager: LocationManagerProtocol { get }
    var garageScreenDIContainer: GarageScreenDIContainerProtocol { get }
    var notificationsScreenDIContainer: NotificationsScreenDIContainerProtocol { get }
    var statisticsScreenDIContainer: StatisticsScreenDIContainerProtocol { get }

    init(storageManager: StorageManagerProtocol,
         locationManager: LocationManagerProtocol,
         networkManager: NetworkManagerProtocol,
         notificationManager: NotificationManagerProtocol)
}

class MainScreenDIContainer: MainScreenDIContainerProtocol {
    var locationManager: LocationManagerProtocol
    var garageScreenDIContainer: GarageScreenDIContainerProtocol
    var notificationsScreenDIContainer: NotificationsScreenDIContainerProtocol
    var statisticsScreenDIContainer: StatisticsScreenDIContainerProtocol
    
    required init(storageManager: StorageManagerProtocol,
                  locationManager: LocationManagerProtocol,
                  networkManager: NetworkManagerProtocol,
                  notificationManager: NotificationManagerProtocol) {
        self.locationManager = locationManager
        self.garageScreenDIContainer = GarageScreenDIContainer(storageManager: storageManager,
                                                               networkManager: networkManager)
        self.notificationsScreenDIContainer = NotificationsScreenDIContainer(notificationManager: notificationManager)
        self.statisticsScreenDIContainer = StatisticsScreenDIContainer(storageManager: storageManager)
    }
}
