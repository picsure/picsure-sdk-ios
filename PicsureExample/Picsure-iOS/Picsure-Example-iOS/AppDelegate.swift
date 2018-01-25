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
        Picsure.configure(withApiKey: "d9f99262b64445e6448aefba38cfc4e888e4ea2f") //Add your API key
        return true
    }
}
