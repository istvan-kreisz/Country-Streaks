//
//  AppDelegate.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/30/20.
//

import UIKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if DebugSettings.shared.resetDatabaseOnLaunch {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
        StoreReviewHelper.incrementAppOpenedCount()

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["ece1182e484279d636df276a2ce5efb5"]

        FirebaseApp.configure()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
