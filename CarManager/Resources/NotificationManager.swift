//
//  NotificationManager.swift
//  CarManager
//
//  Created by Сергей Петров on 05.11.2021.
//

import Foundation
import UserNotifications

protocol NotificationManagerProtocol: UNUserNotificationCenterDelegate {
    func getNotificationSettings()
    func requestAuth()
    func changeTiresNotification(carNickName: String, to tiresType: TyreSeasonType, delay: Double)
    func changeTiresNotification(carNickNames: [Car], to tiresType: TyreSeasonType, delay: Double)
}

class NotificationManager: NSObject, NotificationManagerProtocol {

    private let notificationCenter = UNUserNotificationCenter.current()

    static let shared = NotificationManager()

    override private init() {
        super.init()
        notificationCenter.delegate = self
    }

    public func requestAuth() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, _) in
            print("Permission granted: \(granted)")

            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    public func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("Notification settigs: \(settings)")
        }
    }

    public func changeTiresNotification(carNickName: String,
                                        to tiresType: TyreSeasonType = .summer,
                                        delay: Double = 1) {
        let content = UNMutableNotificationContent()
        content.title = "Смените резину"
        content.body = "В ближайшее время на \(carNickName) необходимо сменить резину на \(tiresType == .summer ? "летнюю" : "зимнюю")!"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let identifier = "set\(tiresType == .summer ? "Summer" : "Winter")TiresIdentifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("NotificationManager error: \(error.localizedDescription)")
            }
        }
    }

    public func changeTiresNotification(carNickNames: [Car], to tiresType: TyreSeasonType = .summer, delay: Double = 1) {
        let content = UNMutableNotificationContent()
        content.title = "Смените резину"
        content.body = "В ближайшее время на нескольких машинах необходимо сменить резину на \(tiresType == .summer ? "летнюю" : "зимнюю")!"
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let identifier = "set\(tiresType == .summer ? "Summer" : "Winter")TiresIdentifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("NotificationManager error: \(error.localizedDescription)")
            }
        }
    }

//    public func changeAntifreezeNotification(carNickName: String) {
//        let content = UNMutableNotificationContent()
//        content.title = "Замените антифриз"
//        content.body = "В скором времени на \(carNickName) потребуется замена антифриза!"
//        content.sound = .default
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let identifier = "changeAntifreezeNotificationIdentifier"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        notificationCenter.add(request) { error in
//            if let error = error {
//                print("NotificationManager error: \(error.localizedDescription)")
//            }
//        }
//    }

//    public func changeAidKitNotification(carNickName: String) {
//        let content = UNMutableNotificationContent()
//        content.title = "Замените аптечку"
//        content.body = "В скором времени на \(carNickName) потребуется замена антечки!"
//        content.sound = .default
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let identifier = "changeAidKitNotificationIdentifier"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        notificationCenter.add(request) { error in
//            if let error = error {
//                print("NotificationManager error: \(error.localizedDescription)")
//            }
//        }
//    }

//    public func changeExtinguisherNotification(carNickName: String) {
//        let content = UNMutableNotificationContent()
//        content.title = "Замените аптечку"
//        content.body = "В скором времени на \(carNickName) потребуется замена огнетушителя!"
//        content.sound = .default
//        content.badge = 1
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let identifier = "changeExtinguisherNotificationIdentifier"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        notificationCenter.add(request) { error in
//            if let error = error {
//                print("NotificationManager error: \(error.localizedDescription)")
//            }
//        }
//    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local notify" {
            print("Handle Local notify!")
        }

        completionHandler()
    }
}
