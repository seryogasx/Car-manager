//
//  AppDelegate.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDIContainer: AppDIContainerProtocol = AppDIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        NotificationManager.shared.requestAuth()
//        LocationManager.shared.requestAccess()

//        let currentDate = Date()
//        let calendar = Calendar.current
//        if let lastWeatherUpdateDate = UserDefaults.standard.value(forKey: "lastWeatherUpdate") as? Date {
//            if calendar.dateComponents([.day], from: calendar.startOfDay(for: lastWeatherUpdateDate), to: calendar.startOfDay(for: currentDate)).day ?? 0 > 3 {
//                NetworkManager.shared.checkWeather()
//            }
//        } else {
//            NetworkManager.shared.checkWeather()
//        }
//        UserDefaults.standard.set(currentDate, forKey: "lastWeatherUpdate")

        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBar.appearance().tintColor = .systemBlue
//        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = appDIContainer.rootViewController
        window?.makeKeyAndVisible()

        return true
    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
