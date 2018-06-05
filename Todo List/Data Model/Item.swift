//
//  Item.swift
//  Todo List
//
//  Created by Pavithra Pravinkumar on 6/4/18.
//  Copyright © 2018 Pavithra Pravinkumar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
