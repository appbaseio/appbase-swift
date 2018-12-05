//
//  Requests.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
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
/// - parameter method: Type of request
/// - parameter appName: Name of application
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data that needs to indexed
/// - parameter header: The additional headers which have to be provided
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func postData(url: String, method: String, app: String, type: String, id: String? = nil, body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Error?) -> ()) {

        var finalURL = url + "/" + app + "/" + type
        
        if id != nil {
            finalURL += "/" + id!
        }
        
        let requestURL = URL(string : finalURL)
        
        do {

            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            var request = URLRequest(url: requestURL!)
            request.httpMethod = method
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
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completionHandler(json, nil)
                    }catch {
                        completionHandler(nil, error)
                    }
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
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter header: The additional headers which have to be provided
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func getData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Error?) -> ()) {

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

        
        URLSession.shared.dataTask(with: request) { (data, response
            , error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json, nil)
                }catch {
                    completionHandler(nil, error)
                }
            }
            
            }.resume()
    }
    
    
/// Initiate the mapping request (GET Request)
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter header: The additional headers which have to be provided
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func getMapping(url: String, app: String, type: String?, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Error?) -> ()) {
        
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
        
        URLSession.shared.dataTask(with: request) { (data, response
            , error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json, nil)
                }catch {
                    completionHandler(nil, error)
                }
            }
            
            }.resume()
    }
    
    
/// Initiate the DELETE request
///
/// - parameter url: Server endpoint URL
/// - parameter app: Name of application
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter header: The additional headers which have to be provided
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func deleteData(url: String, app: String, type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Error?) -> ()) {
        
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
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completionHandler(json, nil)
                    }catch {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
    }
    
}
