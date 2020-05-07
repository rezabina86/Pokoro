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
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let manager = PKSocketManager.shared
    
    var window: UIWindow?
    var router: SceneDelegateRouter?
    var coordinator: AuthenticationCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        makeAuthenticationCoordinator()
        presentAuthenticationCoordinator()
        
        //START OneSignal initialization code
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions, appId: "3bbd9b9a-ccaf-44b3-b55a-a921f41e8bf8", handleNotificationReceived: nil, handleNotificationAction: { (result) in
            guard let chatId = result?.notification.payload.additionalData["chat_id"] as? String else { return }
            PKUserManager.shared.pushNotificationChatId = chatId
        }, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = .none
        
        if let user_id = PKUserManager.shared.userId {
            OneSignal.sendTag("user_id", value: user_id)
        }
        //END OneSignal initializataion code
        
        FirebaseApp.configure()
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        Logger.log(message: url, event: .info)
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "Type01" {
            PKUserManager.shared.userSelectedShortcutItem = true
            completionHandler(true)
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL, let host = url.host, host == "pokoro.app", let code = url.pathComponents.last else { return false }
        PKUserManager.shared.userSelectedNamespaceLink = code
        return true
    }
    
    private func makeAuthenticationCoordinator() {
        router = SceneDelegateRouter(window: window!)
        coordinator = AuthenticationCoordinator(router: router!)
    }
    
    public func presentAuthenticationCoordinator() {
        coordinator?.present(animated: true, onDismissed: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PKUserManager.shared.isAppInForeground = true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        PKUserManager.shared.isAppInForeground = false
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PokoroDBModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
