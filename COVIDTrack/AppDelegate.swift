//
//  AppDelegate.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600 * 6)
        return true
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
                             @escaping (UIBackgroundFetchResult) -> Void) {
        AppManager.checkWatchedGroups() { _, count, message, _ in
            if count > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = "You have \(count) updates"
                content.body = message
                content.sound = UNNotificationSound.default

                let request = UNNotificationRequest(identifier: "COVID Update", content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) {(error) in
                    if let error = error {
                        print("Uh oh! We had an error: \(error)")
                        completionHandler(.failed)
                    } else {
                        completionHandler(.newData)
                    }
                }
            } else {
                completionHandler(.noData)
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

