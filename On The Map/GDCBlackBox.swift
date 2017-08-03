//
//  GDCBlackBox.swift
//  On The Map
//
//  Created by Alan Campos on 7/25/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
