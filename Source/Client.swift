//
//  SwiftElasticSearch.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel And Abhinav Raj
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

/// Entry point in the SwiftElasticSearch library
///
public class Client : NSObject {
    
    // MARK: - Properties
    
    public var url : String
    public var app : String
    public var credentials : String
    var APIkey : Request?
    
    
    // MARK: - Initializer
    
/// Creates an Elastic Search class object for Appbase
///
/// - parameter url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
/// - parameter appID: Name of the application
/// - parameter credentials: User credentials for authentication (Read Key)
///
/// - returns: SwiftElasticSearch class Object
///
    public init(url : String, app : String, credentials : String) {
        self.url = url
        self.app = app
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
        }
    
    // MARK: - Operations
    
/// Adds given JSON data to the database (POST/PUT request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data that needs to indexed. The data must be in valid JSON format. Eg :
///                     let updateParameters:[String:Any] = [
///                         "year": 2018,
///                          "movieName": "La La Land"
///                 ]
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-index_.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-index_.html)
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func index(type: String, id : String? = nil, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            if id != nil {
                APIkey!.putData(url: url, app: app, type: type, id: id, body: body, headers: headers) { ( JSON, response, error ) in
                    
                    if error == nil {
                        completionHandler(JSON, response, nil)
                    }
                    else {
                        completionHandler(nil, response, error)
                    }
                }
            }
            else {
                APIkey!.postData(url: url, app: app, type: type, id: id, body: body, headers: headers) { ( JSON, response, error ) in
                    
                    if error == nil {
                        completionHandler(JSON, response, nil)
                    }
                    else {
                        completionHandler(nil, response, error)
                    }
                }
            }
    }
    
    
/// Fetches data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func get(type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        APIkey?.getData(url: url, app: app, type: type, id: id, headers: headers) {
            JSON, response, error in
            
            if error == nil {
                completionHandler(JSON, response, nil)
            }
            else {
                completionHandler(nil, response, error)
            }
        }
    }
    
    
/// Deletes data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func delete(type: String, id : String, headers: [String: String]? = nil,completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            APIkey!.deleteData(url: url, app: app, type: type, id: id, headers: headers) {
                JSON, response, error in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
}
    
    
/// Update data of the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter body: JSON structured data parameter that has to be passed for updating, Note: For updating data, the JSON
///                must be of the format doc{ JSON FOR THE PARAMETER TO BE UPDATED }. Eg :
///                let updateParameters:[String:Any] = [
///                        "doc": [
///                            "year": 2018
///                            ]
///                        ]
///
///                While updating, all the JSON body needs to be put inside a doc array as shown above else the method won't work.
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func update(type: String, id : String, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            let updateID = id + "/_update"
            
            APIkey!.postData(url: url, app: app, type: type, id: updateID, body: body,headers: headers) { ( JSON, response, error ) in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
        }
    }
    
    
/// Make bulk requests on a specified app or a specific type. Bulk requests can be any of index, update and delete requests.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), should only be passed if you want to make the request to the that perticular type.
/// - parameter body: JSON structured data parameter that has to be passed for updating, Note: For updating data,  the JSON
    ///            must be of the format {"request_type":{JSON}} :
///                { "index": { "_type": "users", "_id": "2" } }
///                { "doc" : {"field2" : "value2"} }
///                { "delete": { "_id": "2" } }
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-bulk.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-bulk.html)
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func bulk(type: String? = nil, body : [String : Any]? = nil, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            var bulk = "/_bulk"
            if type != nil {
                bulk = type! + "/_bulk"
            }
        
            APIkey!.postData(url: url, app: app, type: bulk, body: body!, headers:headers) { ( JSON, response, error ) in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
    }
    
    
/// Make search of JSON documents through given string using Elasticsearch's expressive Query DSL.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), should only be passed if you want to make the request to the that perticular type.
/// - parameter String: The string for which the search has to be made
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func search(type:String, searchString: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            let searchID = "_search?q="+searchString
            
            APIkey?.getData(url: url, app: app, type: type, id: searchID) {
                JSON, response, error in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
    }
    
    
    
/// Apply a search via the request body. The request body is constructed using the Query DSL.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), should only be passed if you want to make the request to the that perticular type.
/// - parameter body: The request body through which the query has to be made.The request body is constructed using the Query DSL.
/// More information on how to make a request body can be found on : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html)
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func msearch(type:String, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            let msearchType = type + "/_search"
            
            APIkey!.postData(url: url, app: app, type: msearchType, body: body,headers: headers) { ( JSON, response, error ) in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
    }
    
    
/// Get streaming updates to a document with the specified id. The stream=true parameter informs the appbase.io service to keep the connection open, which is used to provide subsequent updates.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func getStream(type: String, id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
            let streamID = id + "?stream=true"
            
            APIkey?.getData(url: url, app: app, type: type, id: streamID, headers: headers) {
                JSON, response, error in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
    }
    
    
/// Provides the data mapping corresponding to the app or the type.
///
/// - parameter type: (optional field) Type of data that is created in the app (Appbase dashboard), provide if you want to get the data mapping from the correspong type.
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func getMapping(type:String?=nil , headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()){
            
            APIkey?.getMapping(url: url, app: app, type: type, headers: headers) {
                JSON, response, error in
                
                if error == nil {
                    completionHandler(JSON, response, nil)
                }
                else {
                    completionHandler(nil, response, error)
                }
            }
    }
    
    
/// Provides the number of types which you have made in your appbase dashboard
///
/// - parameter header: The additional headers which have to be provided
///
/// - returns: The number of types in your app.
///
    public func getTypes(headers: [String: String]? = nil)->Int{
                    
            var innerJson:NSDictionary?
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.global().async {
                self.getMapping(headers:headers) {
                    JSON, response, error in
                    
                    innerJson = ((JSON! as? [String:Any])![self.app]! as? [String:Any])!["mappings"]! as? NSDictionary
                    group.leave()
                }
            }
            group.wait()
            
            return (innerJson?.count)! - 2
        }
}
