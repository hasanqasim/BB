//
//  AppDelegate.swift
//  BigBrother
//
//  Created by M Rahman on 1/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

// Code reference for background fetch: https://stackoverflow.com/questions/44313278/ios10-background-fetch

import UIKit
import Firebase
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var databaseController: DatabaseProtocol?
    
    var readingCount = 0
    
    var time = Date()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
       
        var storyboard: UIStoryboard
        if UserDefaults.standard.value(forKey: "deviceID") as? String == nil {
            storyboard = UIStoryboard(name: "Intro", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Login", bundle: nil)
        }
        //storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        databaseController = FirebaseController()
        initializeS3()
        
        requestPermissionNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        databaseController?.removeListener(listener: self)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        databaseController?.addListener(listener: self)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func postLocalNotifications(eventTitle:String){
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "There's someone at your door"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notification)
    }
    
    func requestPermissionNotifications(){
        let application =  UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if( error != nil ){
                    print(error!)
                }
                else{
                    if( isAuthorized ){
                        //print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else{
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                            let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        // Checking for setting is opened or not
                                        print("Setting is opened: \(success)")
                                    })
                                }
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                print("user denied")
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            let viewController = UIApplication.shared.keyWindow!.rootViewController
                            DispatchQueue.main.async {
                                viewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}

extension AppDelegate: DatabaseListener{
    
    func onFirebaseReadingListChange(change: DatabaseChange, firebaseReading: [FirebaseReading]) {
        if time.timeIntervalSinceNow < -30 && firebaseReading.count > 0 {
            
            if readingCount != firebaseReading.count{
                readingCount = firebaseReading.count
                postLocalNotifications(eventTitle: "Motion Detected")
                time = Date()
            }
        }
    }
    
    
}

extension AppDelegate {
    func initializeS3() {
        let poolId = "ap-southeast-2:6db7054e-c739-430d-a6ee-e82cf1da6bcb" // 3-1
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .APSoutheast2, identityPoolId: poolId)//3-2
        let configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        databaseController?.addListener(listener: self)
        completionHandler(UIBackgroundFetchResult.newData)
        databaseController?.removeListener(listener: self)
        
    }
}


