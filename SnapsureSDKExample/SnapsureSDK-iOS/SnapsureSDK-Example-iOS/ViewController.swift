//
//  ViewController.swift
//  SnapsureSDK-Example-iOS
//
//  Created by Nikita Ermolenko on 10/03/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import UIKit
import SnapsureSDK

class ViewController: UIViewController {

    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.sendRequest2()
    }
}

