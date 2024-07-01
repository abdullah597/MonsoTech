//
//  NotificationHelper.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 01/07/2024.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class NotificationHelper: NSObject {
    static let shared = NotificationHelper()
    var fcmToken = ""
    func enablePushNotifications(token: String) {
        let body = PushNotificationBody(oid: Constants.oid, os: "ios", token: "", pushnotificationsenabled: true)
        APIManager.shared.patchData(endpoint: .pushNotification, requestBody: body, viewController: HomeVC()) { (code, result: APIResult<String>) in
            switch result {
            case .success(let t):
                print(t)
            case .failure(let aPIError):
                print(aPIError)
            }
        }
    }
    
    func configure(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension NotificationHelper: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            let presentationOptions: UNNotificationPresentationOptions = [.sound, .badge, .list, .banner]
            completionHandler(presentationOptions)
        } else {
            let presentationOptions: UNNotificationPresentationOptions = [.sound, .badge]
            completionHandler(presentationOptions)
        }
        let userInfo = notification.request.content.userInfo
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcm = \(fcmToken ?? "")")
        enablePushNotifications(token: fcmToken ?? "")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
struct PushNotificationBody: Codable {
    let oid, os, token: String?
    let pushnotificationsenabled: Bool?
}
