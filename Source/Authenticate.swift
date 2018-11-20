//
//  Authenticate.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 09/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

/// Used for authenticating app and type properties used in Client.swift class
///
public class Authenticate {
    
    /// A string consisting of all the alphanumeric and some special characters
    ///
    public var credentials: String
    public var appName: String
    public var url:String
    
    /// init: initialiser of the Authenticate class
    ///
    public init(url:String, app:String, credentials:String) {
        self.appName = app
        self.credentials = credentials
        self.url = url
    }
    
    public func appExists()->Bool{
        let finalURL = url + "/" + appName
        let data = (credentials).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    
        let group = DispatchGroup()
        group.enter()
        let requestURL = URL(string : finalURL)
    
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "HEAD"
        request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        var statusCode:Int?
        DispatchQueue.global().async {
            
            URLSession.shared.dataTask(with: request) { (data, response
                , error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        statusCode = httpResponse.statusCode as Int
                    }
                    group.leave()
                }.resume()
        }
        group.wait()
        return(statusCode == 200)
    }
    
    public func typeExits(type:String)->Bool{
        let finalURL = url + "/" + appName + "/_mapping/" + type
        let data = (credentials).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let group = DispatchGroup()
        group.enter()
        let requestURL = URL(string : finalURL)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        var statusCode:Int?
        DispatchQueue.global().async {
    
            URLSession.shared.dataTask(with: request) { (data, response
                , error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        statusCode = httpResponse.statusCode as Int
                    }
                    group.leave()
                }.resume()
        }
        group.wait()
        return(statusCode == 200)
    }
}
