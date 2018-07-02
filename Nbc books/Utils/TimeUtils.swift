
//
//  TimeUtils.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/2/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class TimeUtils: NSObject {
    public static func toLocalTime(string:String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = TimeZone(abbreviation: "UTC")
        return format.date(from: string)!
    }
}
