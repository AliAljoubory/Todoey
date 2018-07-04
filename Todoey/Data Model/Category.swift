//
//  Category.swift
//  Todoey
//
//  Created by Ali Aljoubory on 21/06/2018.
//  Copyright © 2018 Ali Aljoubory. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
}
