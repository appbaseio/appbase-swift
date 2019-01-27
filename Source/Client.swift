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
    public var credentials : String? = nil
    var APIkey : Request?
    
    
    // MARK: - Initializer
    
/// Instantiates an ElasticSearch client object
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the app (aka search index)
/// - parameter credentials: Basic Auth `username:password` formatted credentials for authentication (if any)
///
/// - returns: SwiftElasticSearch class Object
///
    public init(url : String? = "https://scalr.api.appbase.io", app : String, credentials : String? = nil) {
        self.url = url!
        self.app = app
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
// MARK: - Operations
    
/// Adds a JSON document to the search index (via POST/PUT request)
///
/// - parameter id: ID of the doc to be indexed
/// - parameter type: Type of the doc to be indexed (defaults to `_doc` when not passed)
/// - parameter body: JSON document to be indexed. It must be in a valid JSON format. For more information, read [here](https://www.elastic.co/guide/en/elasticsearch/reference/6.5/docs-index_.html) Eg :
///
///                     let updateParameters:[String:Any] = [
///                         "year": 2018,
///                          "movieName": "La La Land"
///                 ]
/// - parameter headers: Additional headers to be passed along with the `index()` request.
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func index(type: String? = "_doc", id : String? = nil, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        if id != nil {
            APIkey!.putData(url: url, app: app, type: type!, id: id, body: body, headers: headers) { ( JSON, response, error ) in
                
                completionHandler(JSON, response, error)
            }
        }
        else {
            APIkey!.postData(url: url, app: app, type: type!, id: id, body: body, headers: headers) { ( JSON, response, error ) in
                
                completionHandler(JSON, response, error)
            }
        }
    }
    
    
/// Fetches a specified document from the search index (GET request)
///
/// - parameter id: ID of the doc to be fetched
/// - parameter type: Type of the doc to be fetched (defaults to `_doc` when not passed)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func get(type: String? = "_doc", id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        APIkey?.getData(url: url, app: app, type: type!, id: id, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Deletes a specified document from the search index (DELETE request)
///
/// - parameter id: ID of the doc to be deleted
/// - parameter type: Type of the doc to be deleted (defaults to `_doc` when not passed)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func delete(type: String? = "_doc", id : String, headers: [String: String]? = nil,completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        APIkey!.deleteData(url: url, app: app, type: type!, id: id, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Partially update a specified document in the search index. (POST request)
/// It's different from the index() method as it allows to only update the fields specified in the `body.doc` key.
///
/// - parameter id: ID of the doc to be updated
/// - parameter type: Type of the doc to be updated (defaults to `_doc` when not passed)
/// - parameter body: Fields to be updated passed under the `doc` key. The data must be in valid JSON format. Eg :
///
///             let updateParameters: [String:Any] = ["doc": ["year": 2018]]
/// - parameter headers: Additional headers to be passed along
/// While updating, all the JSON body needs to be put inside a doc array as shown above else the method won't work. For more information, read [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html#_updates_with_a_partial_document)
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func update(type: String? = "_doc", id : String, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let updateID = id + "/_update"
        
        APIkey!.postData(url: url, app: app, type: type!, id: updateID, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Make bulk requests on the search index. Bulk requests can be any of index, update and delete requests.
///
/// - parameter type: Type of the documents passed in the bulk request (can also be passed as part of request body)
/// - parameter body: JSON data in the specified format. Note: For updating data, the JSON must be of the format [[String:Any]]. A quick example of bulk request is shown here:
///
///             let bulkParameters:[[String:Any]] = [
///                     [ "index": [ "_type": "SwiftClientES"] ],
///                     ["Title" : "New Movie 4" , "Year" : "2016"],
///                     [ "delete" : ["_id": "testID"]]
///             ]
///
/// For more information, read [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func bulk(type: String? = "_doc", body : [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let bulk = type! + "/_bulk"
        
        APIkey!.bulkData(url: url, app: app, type: bulk, body: body, headers:headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Search across documents in the index. The request body is constructed using the Query DSL.
///
/// - parameter type: Type of the documents to be searched against (optional)
/// - parameter body: Search Query DSL specified in the JSON format.
/// More information on how to specify an ElasticSearch query can be found [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func search(type: String? = "_doc", body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let msearchType = type! + "/_search"
        
        APIkey!.postData(url: url, app: app, type: msearchType, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }


/// Combine multiple search requests into a single request. The individual request bodies are constructed using the Query DSL.
///
/// - parameter type: Type of the documents to be searched against (optional)
/// - parameter body: Multiple queries passed in JSON format, each adhering to the Search Query DSL [query1(json),query2(json)]. 
/// More information on multi search API can be found [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-multi-search.html)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func msearch(type: String? = "_doc", body : [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let msearchType = type! + "/_msearch"
        
        APIkey!.bulkData(url: url, app: app, type: msearchType, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }


/// Get streaming updates to a document with a specified id. The [stream = true] parameter informs the appbase.io service to keep the connection open, which is used to receive subsequent updates.
///
/// - parameter id: ID of the doc to be fetched
/// - parameter type: Type of the doc to be fetched (defaults to `_doc` when not passed)
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Streamed updates as message, each update in a JSON format until the connection is closed
///
    public func getStream(type: String? = "_doc", id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
        
        getStreamData(url: url, credentials: credentials, app: app, type: type!, id: id) { (message) in
            
            completionHandler(message)
        }
    }
    
    
/// Get streaming updates to a search query provided in the request body. The [stream=true] parameter informs the appbase.io service to keep the connection open, which is used to receive subsequent updates.
///
/// - parameter type: Type of the documents to be searched against (optional)
/// - parameter body: Search Query DSL specified in the JSON format
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Streamed updates as message, each update in a JSON format until the connection is closed
///
    public func searchStream(type: String? = "_doc", body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
        
        getSearchStreamData(url: url, credentials: credentials, app: app, type: type!, body: body) { (message) in
            
            completionHandler(message)
        }
    }
    
    
/// Get the data mapping for the search index
///
/// - parameter type: (Optional) If provided, the mapping will be returned for only this particular type.
/// - parameter headers: Additional headers to be passed along
///
/// - returns: Received data, response in JSON format and error information if present in the format (Any?, Any?, Error?)
///
    public func getMapping(type: String? = "_doc" , headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()){
        
        APIkey?.getMapping(url: url, app: app, type: type!, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
}
