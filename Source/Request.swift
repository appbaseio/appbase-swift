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
    
    public var credentials : String
    
    
    // MARK: - Initializer
    
/// Inititate parameters of a request that needs to be made
///
/// - parameter credentials: Credentials of the user
///
    public init(credentials : String) {
        self.credentials = credentials
    }

    
    // MARK: - Methods

/// Initiate the POST request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data that needs to indexed
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func postData(url: String, app: String, type: String, id: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {

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
            
            let tempCredentials = (credentials).data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if receivedData != nil {
                    completionHandler(receivedData, response, nil)
                }
                else {
                    let receivedError = responseInitializer.getReceivedError()
                    completionHandler(nil, response, receivedError)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }
    
/// Initiate the PUT request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of data to be indexed
/// - parameter body: Data that needs to indexed
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func putData(url: String, app: String, type: String, id: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
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
            
            let tempCredentials = (credentials).data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if receivedData != nil {
                    completionHandler(receivedData, response, nil)
                }
                else {
                    let receivedError = responseInitializer.getReceivedError()
                    completionHandler(nil, response, receivedError)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }

    
/// Initiate the GET request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func getData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?,  Error?) -> ()) {

        let finalURL = url + "/" + app + "/" + type + "/" + id
        
        let data = (credentials).data(using: String.Encoding.utf8)
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

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if receivedData != nil {
                completionHandler(receivedData, response, nil)
            }
            else {
                let receivedError = responseInitializer.getReceivedError()
                completionHandler(nil, response, receivedError)
            }
            
        }
        task.resume()
    }
    
    
/// Initiate the mapping request (GET Request)
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func getMapping(url: String, app: String, type: String? = nil, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        var finalURL = url + "/" + app + "/_mapping"
        
        if type != nil {
            finalURL += "/" + type!
        }
        
        let data = (credentials).data(using: String.Encoding.utf8)
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
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if receivedData != nil {
                completionHandler(receivedData, response, nil)
            }
            else {
                let receivedError = responseInitializer.getReceivedError()
                completionHandler(nil, response, receivedError)
            }
            
        }
        task.resume()
        
    }
    
    
/// Initiate the DELETE request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func deleteData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let finalURL = url + "/" + app + "/" + type + "/" + id
        let method = "DELETE"
        
        let requestURL =  URL(string : finalURL)
        
            var request = URLRequest(url: requestURL!)
            request.httpMethod = method
            
            let tempCredentials = (credentials).data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
            
            let receivedData = responseInitializer.getReceivedData()
            
            if receivedData != nil {
                completionHandler(receivedData, response, nil)
            }
            else {
                let receivedError = responseInitializer.getReceivedError()
                completionHandler(nil, response, receivedError)
            }
            
        }
        task.resume()
        
    }
 
    
/// Initiate the bulk POST request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app
/// - parameter body: Data that needs to indexed
/// - parameter headers: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func bulkData(url: String, app: String, type: String, body: [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
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
            
            let tempCredentials = (credentials).data(using: String.Encoding.utf8)
            let credentials64 = tempCredentials!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic " + credentials64, forHTTPHeaderField: "Authorization")
            if headers != nil {
                for (key, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                let responseInitializer = Response.init(data: data, httpResponse: response, error: error)
                
                let receivedData = responseInitializer.getReceivedData()
                
                if receivedData != nil {
                    completionHandler(receivedData, response, nil)
                }
                else {
                    let receivedError = responseInitializer.getReceivedError()
                    completionHandler(nil, response, receivedError)
                }
                
            }
            task.resume()
            
        } catch let err {
            print("Error", err)
        }
        
    }
}
