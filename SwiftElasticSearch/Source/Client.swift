//
//  SwiftElasticSearch.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel And Abhinav Raj
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public class Client : NSObject {
    
    public var url : String
    public var app : String
    public var credentials : String
    var APIkey : Request?
    let util = Utils()
    
    
/// Creates an Elastic Search class object for Appbase
///
/// - parameter url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
/// - parameter appID: Name of the application
/// - parameter credentials: User credentials for authentication (Read Key)
///
/// - returns: SwiftElasticSearch class Object
///
    public init(url baseURL : String, appName : String, credentials : String) {
        self.url = baseURL
        self.app = appName
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
    
/// Adds given JSON data to the database (POST/PUT request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data parameters that needs to send (Can be nil). The data must be in valid JSON format. Eg :
///                     let updateParameters:[String:Any] = [
///                         "doc": [
///                            "year": 2018
///                        ]
///                 ]
///                For more information visit: "https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document"
///
/// - returns: Void
///
    public func index(type: String, id : String? = nil, body : [String : Any]? = nil) {
  
        var method = util.getRequestType(RequestString: "POST")
        if id != nil {
            method = util.getRequestType(RequestString: "PUT")
        }
            
        APIkey!.postData(url: url, type: type, method: method, appName: app, id: id, body: body)
    }
    
    
/// Fetches data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: JSON object in format [String : Any]?
///
    public func get(type: String, id: String, completionHandler: @escaping ([String : Any]?, Error?) -> ()) {
        
        APIkey?.getData(url: url, type: type, appName: app, id: id) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Deletes data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: Void
///
    public func delete(type: String, id : String) {
        
        let method = util.getRequestType(RequestString: "DELETE")
        
        APIkey!.deleteData(url: url, type: type, method: method, appName: app, id: id)
    }
    
    
/// Update data of the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query (Can be nil)
/// - parameter body: JSON structured data parameter that has to be passed for updating, Note: For updating data, the JSON
///                must be of the format doc{ JSON FOR THE PARAMETER TO BE UPDATED }. Eg :
///                let updateParameters:[String:Any] = [
///                        "doc": [
///                            "year": 2018
///                            ]
///                        ]
///                For more information visit: "https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document"
///
/// - returns: Void
///
    public func update(type: String, id : String, body : [String : Any]? = nil) {
        
        let method = util.getRequestType(RequestString: "POST")
        let updateID = id + "/_update"
        
        APIkey!.postData(url: url, type: type, method: method, appName: app, id: updateID, body: body)
    }
    
}
