//
//  Requests.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel and Abhinav Raj on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

/// Class to handle the GET, POST PUT and DELETE requests made from any class inside the library
///
public class Request {
    
    // MARK: - Properties
/// - Basic Auth `username:password` formatted credentials for authentication (if any)
    public var credentials : String? = nil
    
    
    // MARK: - Initializer
    
/// Inititate parameters of a request that needs to be made
///
/// - parameter credentials: Basic Auth `username:password` formatted credentials for authentication (if any)
///
    public init(credentials : String? = nil) {
        self.credentials = credentials
    }

    
    // MARK: - Methods

/// Initiate the POST request
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc to be indexed (defaults to `_doc` when not passed)
/// - parameter id: ID of the doc to be indexed (optional)
/// - parameter body: JSON structured data that needs to be indexed
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func postData(url: String, app: String, type: String, id: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, String?) -> ()) {

        var finalURL = url + "/" + app + "/" + type
        
        if id != nil {
            finalURL += "/" + id!
        }
        
        let requestURL = URL(string : finalURL)
        
        do {

            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            var request = URLRequest(url: requestURL!)
            request.httpMethod = "POST"
            request.httpBody = data
            
            if credentials != nil {
                let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
                let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            }
    
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if responseInitializer.isErrorEncountered() {
                    
                    let errStatement = responseInitializer.getReceivedStatusFromCode()
                    completionHandler(receivedData, response, errStatement)
                    
                } else {
                    completionHandler(receivedData, response, nil)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }
    
/// Initiate the PUT request
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc to be indexed (defaults to `_doc` when not passed)
/// - parameter id: ID of the doc to be indexed (optional)
/// - parameter body: JSON structured data that needs to be indexed
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func putData(url: String, app: String, type: String, id: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, String?) -> ()) {
        
        var finalURL = url + "/" + app + "/" + type
        
        if id != nil {
            finalURL += "/" + id!
        }
        
        let requestURL = URL(string : finalURL)
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            var request = URLRequest(url: requestURL!)
            request.httpMethod = "PUT"
            request.httpBody = data
            
            if credentials != nil {
                let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
                let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            }

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if responseInitializer.isErrorEncountered() {
                    
                    let errStatement = responseInitializer.getReceivedStatusFromCode()
                    completionHandler(receivedData, response, errStatement)
                    
                } else {
                    completionHandler(receivedData, response, nil)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }

    
/// Initiate the GET request
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc to be fetched (defaults to `_doc` when not passed)
/// - parameter id: ID of the doc to be fetched (optional)
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func getData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?,  String?) -> ()) {

        let finalURL = url + "/" + app + "/" + type + "/" + id
        
        let requestURL = URL(string : finalURL)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        if credentials != nil {
            let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if responseInitializer.isErrorEncountered() {
                
                let errStatement = responseInitializer.getReceivedStatusFromCode()
                completionHandler(receivedData, response, errStatement)
                
            } else {
                completionHandler(receivedData, response, nil)
            }
            
        }
        task.resume()
    }
    
    
/// Initiate the mapping request (GET Request)
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc whose mapping is required (defaults to `_doc` when not passed)
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func getMapping(url: String, app: String, type: String? = nil, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, String?) -> ()) {
        
        var finalURL = url + "/" + app + "/_mapping"
        
        if type != nil {
            finalURL += "/" + type!
        }
        
        let requestURL = URL(string : finalURL)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        if credentials != nil {
            let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if responseInitializer.isErrorEncountered() {
                
                let errStatement = responseInitializer.getReceivedStatusFromCode()
                completionHandler(receivedData, response, errStatement)
                
            } else {
                completionHandler(receivedData, response, nil)
            }
            
        }
        task.resume()
        
    }
    
    
/// Initiate the DELETE request
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc (defaults to `_doc` when not passed)
/// - parameter id: ID of the doc to be deleted
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func deleteData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, String?) -> ()) {
        
        let finalURL = url + "/" + app + "/" + type + "/" + id
        let method = "DELETE"
        
        let requestURL =  URL(string : finalURL)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = method
            
        if credentials != nil {
            let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if responseInitializer.isErrorEncountered() {
                
                let errStatement = responseInitializer.getReceivedStatusFromCode()
                completionHandler(receivedData, response, errStatement)
                
            } else {
                completionHandler(receivedData, response, nil)
            }
            
        }
        task.resume()
        
    }
 
    
/// Initiate the bulk POST request
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter type: Type of the doc to be indexed (defaults to `_doc` when not passed)
/// - parameter body: JSON structured data that needs to be indexed
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, String?)
///
    public func bulkData(url: String, app: String, type: String, body: [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, String?) -> ()) {
        
        let finalURL = url + "/" + app + "/" + type         
        let requestURL = URL(string : finalURL)
        
        do {
            
            var requestBody:Data = Data(capacity: 2000)
            
            for data in body {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                requestBody.append(jsonData)
                requestBody.append(10)
            }
            
            var request = URLRequest(url: requestURL!)
            request.httpMethod = "POST"
            request.httpBody = requestBody
            
            if credentials != nil {
                let tempCredentials = (credentials)!.data(using: String.Encoding.utf8)
                let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if responseInitializer.isErrorEncountered() {
                    
                    let errStatement = responseInitializer.getReceivedStatusFromCode()
                    completionHandler(receivedData, response, errStatement)
                    
                } else {
                    completionHandler(receivedData, response, nil)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }
}
