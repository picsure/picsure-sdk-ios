//
//  AppDelegate.swift
//  SnapsureSDK-Example-iOS
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import UIKit
import SnapsureSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SnapsureSDK.configure(withApiKey: "developer-a3a2e467-999e-4d57-abc6-b0ed90f1c48f")
        return true
    }
}
