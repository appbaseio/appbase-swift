//
//  WebSockets.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel and Abhinav Raj on 01/01/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation

/// Get streaming updates to a document with the specified id
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter credentials: Basic Auth `username:password` formatted credentials for authentication (Read Key)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc
/// - parameter id:  ID of the doc on which getStream has to be made.
/// - parameter headers: Additional headers to be passed along with the request.
///
/// - returns: Received message in JSON format until the connection is closed
///
public func getStreamData(url: String, credentials: String? = nil, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
    
    let seperatedURL = url.split(separator: "/")
    let finalURL = "wss://" + seperatedURL[1] + "/" + app
    
    let requestURL = URL(string : finalURL)
    var request = URLRequest(url: requestURL!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if headers != nil {
        for (key, value) in headers! {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    let query = ",\"path\" : \"" + app + "/" + type + "/" + id + "?stream=true\"}"
    
    let request2 : [String : Any] = [
        "id" : "17f1f527-325a-48f7-a12d-3f16107190cc",
        "method" : "GET",
        "body" : [],
        ]
    
    let ws = WebSocket(url: requestURL!)
    var jsonRequest = stringify(json: request2 as AnyObject)
    jsonRequest.removeLast()
    if credentials != nil {
        let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
        let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        let authorization =  ",\"authorization\" : \"Basic " + credentials64 + "\""
        jsonRequest = jsonRequest + authorization
    }
    
    ws.send(jsonRequest + query)
    
    // Socket Opened
    ws.event.open = {
        NSLog("Socket Opened");
    }
    
    // Socket Closed
    ws.event.close = { code, reason, clean in
        NSLog("Socket Closed");
        NSLog("Reason: \(reason)");
        NSLog("Clean: \(clean)");
    }
    
    // Error
    ws.event.error = { error in
        NSLog("Error: \(error)");
    }
    
    // Data obtained
    ws.event.message = { message in
        
        let str = message as? String ?? ""
        
        do {
            
            if let json = str.data(using: String.Encoding.utf8) {
                
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject] {
                    completionHandler(jsonData["body"])
                }
            }
            
        } catch {
            print(error.localizedDescription)
            completionHandler(message)
        }
    }
    
}


/// Get streaming updates to a search query provided in the request body
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter credentials: Basic Auth `username:password` formatted credentials for authentication (Read Key)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc
/// - parameter body: Search query of the streaming
/// - parameter headers: Additional headers to be passed along with the request.
///
/// - returns: Received message in JSON format until the connection is closed
///
public func getSearchStreamData(url: String, credentials: String? = nil, app: String, type: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
    
    let seperatedURL = url.split(separator: "/")
    let finalURL = "wss://" + seperatedURL[1] + "/" + app
    
    let requestURL = URL(string : finalURL)
    var request = URLRequest(url: requestURL!)
    
    do {
        request.httpMethod = "POST"
        let httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let query:String
        if type != nil {
            query = ",\"path\" : \"" + app + "/" + type! + "/_search?stream=true\"}"
        } else {
            query = ",\"path\" : \"" + app + "/_search?stream=true\"}"
        }
        
        let request2 : [String : Any] = [
            "id" : "17f1f527-325a-48f7-a12d-3f16107190cc",
            "method" : "POST",
            "body" : [],
            ]
        
        let ws = WebSocket(url: requestURL!)
        var jsonRequest = stringify(json: request2 as AnyObject)
        jsonRequest.removeLast()
        if credentials != nil {
            let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            let authorization =  ",\"authorization\" : \"Basic " + credentials64 + "\""
            jsonRequest = jsonRequest + authorization
        }
        
        ws.send(jsonRequest + query)
        
        // Socket Opened
        ws.event.open = {
            NSLog("Socket Opened");
        }
        
        // Socket Closed
        ws.event.close = { code, reason, clean in
            NSLog("Socket Closed");
            NSLog("Reason: \(reason)");
            NSLog("Clean: \(clean)");
        }
        
        // Error
        ws.event.error = { error in
            NSLog("Error: \(error)");
        }
        
        // Data obtained
        ws.event.message = { message in
            
            let str = message as? String ?? ""
            
            do {
                
                if let json = str.data(using: String.Encoding.utf8) {
                    
                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject] {
                        completionHandler(jsonData["body"])
                    }
                }
                
            } catch {
                print(error.localizedDescription)
                completionHandler(message)
            }
        }
        
    }
    catch let err {
        print("Data Parsing Error: ", err)
    }
}
