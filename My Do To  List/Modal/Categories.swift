//
//  Categories.swift
//  My Do To  List
//
//  Created by Bekir Duran on 11.04.2020.
//  Copyright © 2020 info. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Categories: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var CellbgColor: String = ""
    var items = List<Items>()
}
