//
//  MainVC.swift
//  CarManager
//
//  Created by Сергей Петров on 13.04.2022.
//

import Foundation
import UIKit

protocol MainViewControllerProtocol: UITabBarController {
    var DIContainer: MainScreenDIContainerProtocol { get }
    func createTabBar()
    init(mainScreenDIContainer: MainScreenDIContainerProtocol)
}

class MainViewController: UITabBarController, MainViewControllerProtocol {
    
    var DIContainer: MainScreenDIContainerProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    required init(mainScreenDIContainer: MainScreenDIContainerProtocol) {
        self.DIContainer = mainScreenDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController {
    func createTabBar() {
        let garageVC = DIContainer.garageScreenDIContainer.view
        let navigationGarageVC = UINavigationController(rootViewController: garageVC)
        let statisticsVC = DIContainer.statisticsScreenDIContainer.getView()
        let notificationsVC = DIContainer.notificationsScreenDIContainer.view

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
