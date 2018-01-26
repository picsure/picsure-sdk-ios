//
//  AppDelegate.swift
//  Picsure-Example-iOS
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Picsure. All rights reserved.
//

import UIKit
import Picsure

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Picsure.configure(withApiKey: <# Your API key #>)
        return true
    }
}
