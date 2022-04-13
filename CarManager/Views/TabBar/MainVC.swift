//
//  MainVC.swift
//  CarManager
//
//  Created by Сергей Петров on 13.04.2022.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
}

extension MainViewController {
    private func createTabBar() {
        let garageVC = GarageViewController()
        let navigationGarageVC = UINavigationController(rootViewController: garageVC)
        let statisticsVC = StatisticsViewController()
        let notificationsVC = NotificationsViewController()
        
        let bold = UIImage.SymbolConfiguration(weight: .medium)
        garageVC.tabBarItem.image = UIImage(systemName: "bag.fill", withConfiguration: bold)
        statisticsVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill", withConfiguration: bold)
        notificationsVC.tabBarItem.image = UIImage(systemName: "newspaper.fill", withConfiguration: bold)
        
        garageVC.tabBarItem.title = "Гараж"
        statisticsVC.tabBarItem.title = "Статистика"
        notificationsVC.tabBarItem.title = "Уведомления"
        
        viewControllers = [navigationGarageVC, statisticsVC, notificationsVC]
    }
}
