//
//  WebSockets.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 01/01/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation

/// Get streaming updates to a document with the specified id
///
/// - parameter url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
/// - parameter credentials: User credentials for authentication (Read Key)
/// - parameter app: Name of the application
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of query
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received message in JSON format having parameters channel - Path where streaming is made and event - The change that is observed
///
public func getStreamData(url: String, credentials: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
    
    let seperatedURL = url.split(separator: "/")
    let finalURL = "wss://" + seperatedURL[1] + "/" + app
    
    let data = credentials.data(using: String.Encoding.utf8)
    let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    
    let requestURL = URL(string : finalURL)
    var request = URLRequest(url: requestURL!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
    
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
        "authorization" : "Basic " + credentials64,
        ]
    
    let ws = WebSocket(url: requestURL!)
    var jsonRequest = stringify(json: request2 as AnyObject)
    jsonRequest.removeLast()
    
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
        completionHandler(message)
    }
}


/// Get streaming updates to a search query provided in the request body
///
/// - parameter url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
/// - parameter credentials: User credentials for authentication (Read Key)
/// - parameter app: Name of the application
/// - parameter type: Type of data that is created in the app
/// - parameter body: Search query of the streaming
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received message in JSON format until the connection is closed
///
public func getSearchStreamData(url: String, credentials: String, app: String, type: String, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
    
    let seperatedURL = url.split(separator: "/")
    let finalURL = "wss://" + seperatedURL[1] + "/" + app
    
    let data = credentials.data(using: String.Encoding.utf8)
    let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    
    let requestURL = URL(string : finalURL)
    var request = URLRequest(url: requestURL!)
    
    do {
        request.httpMethod = "POST"
        let httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        
        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let query = ",\"path\" : \"" + app + "/" + type + "/_search?stream=true\"}"
        
        let request2 : [String : Any] = [
            "id" : "17f1f527-325a-48f7-a12d-3f16107190cc",
            "method" : "POST",
            "body" : [],
            "authorization" : "Basic " + credentials64,
            ]
        
        let ws = WebSocket(url: requestURL!)
        var jsonRequest = stringify(json: request2 as AnyObject)
        jsonRequest.removeLast()
        
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
            completionHandler(message)
        }
    }
    catch let err {
        print("Data Parsing Error: ", err)
    }
}
