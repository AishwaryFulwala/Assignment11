//
//  NoticeClass.swift
//  Assignment11
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation

class NoticeClass {
    
    var id : Int = 0
    var title : String = ""
    var date : String = ""
    var description : String = ""
    
    init(id : Int, title : String, date : String, description : String) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
    }
}
