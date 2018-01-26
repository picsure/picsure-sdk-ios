//
//  Notification.swift
//  Snapsure-iOS
//
//  Created by Artem Novichkov on 22/06/2017.
//  Copyright © 2017 Snapsure. All rights reserved.
//

import Foundation

protocol Notification {
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
    func removeObserver(_ observer: Any)
}

extension NotificationCenter: Notification {}
