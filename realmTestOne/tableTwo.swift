//
//  tableTwo.swift
//  realmTestOne
//
//  Created by kiddchantw on 2017/11/6.
//  Copyright © 2017年 kiddchantw. All rights reserved.
//

import UIKit
import RealmSwift

class tableTwo: Object {
    private(set) dynamic var uuid:String = UUID().uuidString
    dynamic var libtitle:String = ""
    dynamic var libaddress:String = ""
    
    override static func primaryKey() -> String {
        return "uuid"
    }
    

}
