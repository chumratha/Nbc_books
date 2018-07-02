//
//  WSBase.swift
//  Nbc books
//
//  Created by Chum Ratha on 7/2/18.
//  Copyright © 2018 Chum Ratha. All rights reserved.
//

import UIKit

var baseUrl = "http://167.99.69.77/nbc/api/v1/"

class WSBase: NSObject , URLSessionDelegate {
    
    var data:[String:Any]?
    var params:[String]? // exaple api/id/name/sex
    
    func method() -> String {
        return "GET"
    }
    
    func suffix() -> String {
        return ""
    }
    
    private func doRequest(success:((_ id:Any)->Void)? , error:((_ error:String)->Void)?)  throws {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        var url:String = baseUrl + self.suffix()
        let urlRequest = NSMutableURLRequest(url: URL(string: url)!)
        // set header
        urlRequest.setValue("Bearer o8riW+/xp8ozGYIR757jVo/fKmY3A/Qx/1Un7SpBIYGUzOzPJiRzVk6eIb+mv3aR7VNZJ1/3M7hewnyoUrOloZdV9A1pVUOgjnaPkboInqdJeqm4iJxsCJDy7Fef2+5GJCDulUyD0vM+JaWJyhhzzgRQErIcbe+sZ3Fj3AtPinU=", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = self.method()
        if let data  = self.data {
            if self.method().uppercased() == "POST" || self.method().uppercased() == "PUT" {
                let _data = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
                let stringJson = String(data: _data, encoding: String.Encoding.utf8)
                urlRequest.httpBody = stringJson?.data(using: String.Encoding.utf8)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            else{
                url = "\(url)?"
                for (key,value) in data {
                    url = "\(url)\(key)=\(value)&&"
                }
                url = url.substring(to: url.index(url.startIndex, offsetBy: (url as NSString).length - 2))
                urlRequest.url = NSURL(string: url) as URL?
            }
        }
        else if let params = self.params{
            for val:String in params{
                url = url + "/" + val
            }
            urlRequest.url = URL(string: url)!
        }
        print((urlRequest.url?.absoluteString)!)
        session.dataTask(with: urlRequest as URLRequest) { (d,res,err) in
            if let err = err{
                error!((err.localizedDescription))
            }
            else{
                do{
                    let resultData = try JSONSerialization.jsonObject(with: d!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    success!(self.parseData(data: resultData))
                }
                catch let e as NSError {
                    let str = String(data: d!, encoding: String.Encoding.utf8)
                    if str != nil && (str?.lowercased().contains("success"))! {
                        success!(["status":str!])
                    }
                    else {
                        error!(e.localizedDescription)
                    }
                }
            }
            }.resume()
    }
    
    
    func request(success:((_ id:Any)->Void)? , error:((_ error:String)->Void)?) {
        do {
            try self.doRequest(success: success, error: error)
        } catch let e as NSError {
            if error != nil {
                error!(e.localizedDescription)
            }
        }
    }
    
    func parseData(data:Any) -> Any {
        return data
    }
    
}
