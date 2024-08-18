//
//  Applegate.swift
//  Cat
//
//  Created by Ray on 2024/8/13.
//

import UIKit
import UserNotifications



class Applegate: NSObject, UIApplicationDelegate {
  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
    UNUserNotificationCenter.current().delegate = self
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .provisional, .sound, .badge]) { granted, error in
      guard let error else {
        if granted {
          UIApplication.shared.registerForRemoteNotifications()
        }
        
        return
      }
    }
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
  }
}

extension Applegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    
    return [.banner, .badge, .sound, .list]
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    
  }
}

// Reference = https://github.com/Dimillian/IceCubesApp/blob/main/Packages/Env/Sources/Env/PushNotificationsService.swift#L32
extension UNUserNotificationCenter: @unchecked Sendable {}
extension UNNotification: @unchecked Sendable {}
extension UNNotificationResponse: @unchecked Sendable {}
