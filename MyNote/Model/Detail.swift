//
//  Detail.swift
//  MyNote
//
//  Created by trungnghia on 4/13/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import Foundation
import RealmSwift

class Detail: Object {
    @objc dynamic var text: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "details")
}
