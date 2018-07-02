//
//  WSListBooks.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/2/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

class WSListBooks: WSBase {
    var page = 1
    override func suffix() -> String {
        return "books?page=\(page)"
    }
    
    override func parseData(data: Any) -> Any {
        var listBook:[Book] = []
        if let responseData = data as? [String:Any] , (responseData["success"] as! Int) == 1 {
            for var book in (responseData["data"] as! [String:Any])["data"] as! [[String:Any]] {
                let b = Book()
                b.id = book["id"] as? Int
                b.title = book["title"] as? String
                b.active = (book["active"] as? Int) == 1 ? true : false
                b.publishedDate = TimeUtils.toLocalTime(string: book["published_date"] as! String)
                listBook.append(b)
                
                for var page in book["attachments"] as! [[String:Any]]{
                    let p = BookPage()
                    p.id = page["id"] as? Int
                    p.name = page["name"] as? String
                    p.url = page["url"] as? String
                    p.type = BookPage.PageType(rawValue: page["type"] as! String)
                    p.page = page["page"] as! Int
                    b.pages.append(p)
                }
            }
        }
        
        return listBook
    }
    
}
