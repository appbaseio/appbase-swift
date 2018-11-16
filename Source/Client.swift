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
///                         "doc": [
///                            "year": 2018
///                        ]
///                 ]
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func index(type: String, id : String? = nil, body : [String : Any], completionHandler: @escaping (Any?, Error?) -> ()) {
  
        var method = "POST"
        if id != nil {
            method = "PUT"
        }
            
        APIkey!.postData(url: url, method: method, app: app, type: type, id: id, body: body) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Fetches data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func get(type: String, id: String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        APIkey?.getData(url: url, app: app, type: type, id: id) {
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
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func delete(type: String, id : String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        APIkey!.deleteData(url: url, app: app, type: type, id: id) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
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
///                For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    public func update(type: String, id : String, body : [String : Any], completionHandler: @escaping (Any?, Error?) -> ()) {
        
        let method = "POST"
        let updateID = id + "/_update"
        
        APIkey!.postData(url: url, method: method, app: app, type: type, id: updateID, body: body) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
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
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    
    public func bulk(type: String? = nil, body : [String : Any]? = nil,completionHandler: @escaping (Any?, Error?) -> ()){
        let method = "POST"
        var bulk = "/_bulk"
        if type != nil {
            bulk = type! + "/_bulk"
        }
        APIkey!.postData(url: url, method: method, app: app, type: bulk, body: body!) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
/// Make search of JSON documents through given string using Elasticsearch's expressive Query DSL.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), should only be passed if you want to make the request to the that perticular type.
/// - parameter String: The string for which the search has to be made
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    
    public func search(type:String, searchString: String,  completionHandler: @escaping (Any?, Error?) -> ()){
        
        let searchID = "_search?q="+searchString
        
        APIkey?.getData(url: url, app: app, type: type, id: searchID) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
    
/// Apply a search via the request body. The request body is constructed using the Query DSL.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), should only be passed if you want to make the request to the that perticular type.
/// - parameter body: The request body through which the query has to be made.The request body is constructed using the Query DSL.
/// More information on how to make a request body can be found on : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html)
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    
    
    public func msearch(type:String, body : [String : Any],completionHandler: @escaping (Any?, Error?) -> ()){
        
        let msearchType = type + "/_search"
        let method = "POST"
        
        APIkey!.postData(url: url, method: method, app: app, type: msearchType, body: body) { ( JSON, error ) in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
/// Get streaming updates to a document with the specified id. The stream=true parameter informs the appbase.io service to keep the connection open, which is used to provide subsequent updates.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter id: ID of query
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    
    public func getStream(type: String, id: String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        let streamID = id + "?stream=true"
        
        APIkey?.getData(url: url, app: app, type: type, id: streamID) {
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
    
/// Provides the data mapping corresponding to the app or the type.
///
/// - parameter type: (optional field) Type of data that is created in the app (Appbase dashboard), provide if you want to get the data mapping from the correspong type.
///
/// - returns: JSON response and the error occured if any in format (Any?, Error?)
///
    
    public func getMapping(type:String?,completionHandler: @escaping (Any?, Error?) -> ()){
       
        APIkey?.getMapping(url: url, app: app, type: type){
            JSON, error in
            
            if error == nil {
                completionHandler(JSON,nil)
            }
            else {
                completionHandler(nil,error)
            }
        }
    }
}