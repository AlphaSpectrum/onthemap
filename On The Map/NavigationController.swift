//
//  NavigationController.swift
//  OnTheMap
//
//  Created by Alan Campos on 8/9/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

// This class resolves a bug where the rotation override for a ViewController that is embeded in a Navigation Controller still rotates
class NavigationController: UINavigationController {
    override var shouldAutorotate: Bool {
        return false
    }
}
