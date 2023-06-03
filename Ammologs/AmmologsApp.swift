//
//  AmmologsApp.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI
import UIKit

let quickActionSettings = QuickActionSettings()
var shortcutItemToProcess: UIApplicationShortcutItem?

@main
struct AmmologsApp: App {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(quickActionSettings)
        }
        .onChange(of: phase) { (newPhase) in
            switch newPhase {
            case .active :
                print("App in active")
                guard let type = shortcutItemToProcess?.type as? String else {
                    return
                }
                switch type {
                    case "AddNewSessionItem":
                        print("AddNewSessionItem is selected")
                        quickActionSettings.isAddingSession = true
                    default:
                        print("default ")
                    }
                shortcutItemToProcess = nil
            case .inactive:
                 print("App is inactive")
            case .background:
                print("App in Back ground")
            @unknown default:
                print("default")
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let shortcutItem = UIApplicationShortcutItem(type: "AddNewSessionItem",
                                                     localizedTitle: NSLocalizedString("Sessions", comment: ""),
                                                     localizedSubtitle: NSLocalizedString("Add Item", comment: ""),
                                                     icon: UIApplicationShortcutIcon(systemImageName: "figure.hunting"))
        UIApplication.shared.shortcutItems = [shortcutItem]
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        
        return sceneConfiguration
    }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
}
