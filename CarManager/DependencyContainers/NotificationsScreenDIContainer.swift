//
//  NotificationsScreenDIContainer.swift
//  CarManager
//
//  Created by Сергей Петров on 26.04.2022.
//

import Foundation
import UIKit

protocol NotificationsScreenDIContainerProtocol {
    var view: NotificationsViewControllerProtocol { get }
    var viewModel: NotificationsViewModelProtocol { get }
    init(notificationManager: NotificationManagerProtocol)
}

class NotificationsScreenDIContainer: NotificationsScreenDIContainerProtocol {
    var view: NotificationsViewControllerProtocol
    var viewModel: NotificationsViewModelProtocol
    
    required init(notificationManager: NotificationManagerProtocol) {
        viewModel = NotificationsViewModel()
        view = NotificationsViewController(viewModel: viewModel)
    }
}
