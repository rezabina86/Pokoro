//
//  AppDelegate.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let manager = PKSocketManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PKUserManager.shared.token = "wrWCRqKZ62nLvFyqDmkATH"
        PKUserManager.shared.userId = "5e7dce08bb288a2e471536e8"
        manager.delegate = self
        manager.connect()
        
        return true
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

extension AppDelegate: PKSocketManagerDelegate {
    
    func pkSocketManagerClientStatusChanged(_ manager: PKSocketManager, event: SocketClientEvent) {
        if event == .connect {
            manager.authenticate(model: AuthenticateBusinessModel(session: "nDC4UETSN1Mph6tmNsC68Y"))
        }
        print(event)
    }
    
    func pkSocketManagerDidReceive(_ manager: PKSocketManager, _ message: GetMessageBusinessModel) {
        print(message)
    }
    
    func pkSocketManagerDidAuthenticate(_ manager: PKSocketManager) {
        print("Authenticated")
    }
    
}
