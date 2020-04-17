//
//  Items.swift
//  My Do To  List
//
//  Created by Bekir Duran on 11.04.2020.
//  Copyright © 2020 info. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
    @objc dynamic var dateCreated: Date?
}
