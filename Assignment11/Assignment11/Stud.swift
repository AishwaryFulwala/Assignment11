//
//  Stud.swift
//  Assignment11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation

class Stud {
    
    var spid : Int = 0
    var name : String = ""
    var pwd : String = ""
    var Class: String = ""
    var phone : String = ""
    
    init(spid : Int, name : String, pwd : String, Class : String, phone : String) {
        self.spid = spid
        self.name = name
        self.pwd = pwd
        self.Class = Class
        self.phone = phone
    }
}
