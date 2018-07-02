//
//  Book.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/1/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class BookPage: BaseModel {
    
    enum PageType:String {
        case COVER
        case PAGE
    }
    
    var name:String!
    var referenceId:Int!
    var referenceTable:Int!
    var url:String!
    var type:PageType!
    var page:Int!
}
