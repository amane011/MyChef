//
//  AppDelegate.swift
//  MyChef
//
//  Created by Ankit  Mane on 11/26/23.
//

import UIKit
import AWSCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize AWS service configuration
           let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest1, identityPoolId: "us-west-1:eef05552-b4a9-4471-8f63-f9bdccf7bec2")
            credentialsProvider.getIdentityId().continueWith { (task: AWSTask<NSString>) -> Any? in
            if let error = task.error {
                print("Error")
            }
            return nil
        }
           let configuration = AWSServiceConfiguration(region: .USWest1, credentialsProvider: credentialsProvider)
           
           AWSServiceManager.default().defaultServiceConfiguration = configuration
        
//        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
//        AWSDDLog.sharedInstance.logLevel = .verbose

           
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

