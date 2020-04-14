//
//  Catagory.swift
//  MyNote
//
//  Created by trungnghia on 4/13/20.
//  Copyright © 2020 trungnghia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let details = List<Detail>()
}
