//
//  AppDelegate.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import SocketIO
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let manager = PKSocketManager.shared
    
    var window: UIWindow?
    var router: SceneDelegateRouter?
    var coordinator: AuthenticationCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        setTheme()
        makeAuthenticationCoordinator()
        presentAuthenticationCoordinator()
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "3bbd9b9a-ccaf-44b3-b55a-a921f41e8bf8",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            if let user_id = PKUserManager.shared.userId {
                OneSignal.sendTag("user_id", value: user_id)
            }
        })
        
        if let user_id = PKUserManager.shared.userId {
            OneSignal.sendTag("user_id", value: user_id)
        }
        //END OneSignal initializataion code
        
        return true
    }
    
    private func makeAuthenticationCoordinator() {
        router = SceneDelegateRouter(window: window!)
        coordinator = AuthenticationCoordinator(router: router!)
    }
    
    public func presentAuthenticationCoordinator() {
        coordinator?.present(animated: true, onDismissed: nil)
    }
    
    private func setTheme() {
        guard let style = window?.traitCollection.userInterfaceStyle else { return }
        ThemeManager.shared.set(theme: style == .light ? LightTheme() : DarkTheme())
    }
    
}

