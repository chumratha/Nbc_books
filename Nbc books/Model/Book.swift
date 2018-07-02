//
//  Author.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/1/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class Book: BaseModel {
    var title:String!
    var desc:String!
    var author:String!
    var publishedDate:Date!
    var active:Bool!
    var pages:[BookPage] = []
}
