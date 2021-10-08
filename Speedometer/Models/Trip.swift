//
//  Trip.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 19.02.2021.
//  Copyright © 2021 Daniil Marusenko. All rights reserved.
//

import Foundation
import RealmSwift

class Trip: Object {

    @objc dynamic var date: String = ""
    @objc dynamic var distance: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var maxSpeed: String = ""
    @objc dynamic var avgSpeed: String = ""
    @objc dynamic var firstAccelTime: String = ""
    @objc dynamic var secondAccelTime: String = ""
    @objc dynamic var thirdAccelTime: String = ""
    @objc dynamic var fourthAccelTime: String = ""
    @objc dynamic var fifthAccelTime: String = ""
    @objc dynamic var sixthAccelTime: String = ""
    
}
