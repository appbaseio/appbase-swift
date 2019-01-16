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
    
/// Instantiates an ElasticSearch client object
///
/// - parameter url: URL of the ElasticSearch host server (If application is hosted on appbase.io, url should be https://scalr.api.appbase.io)
/// - parameter app: Name of the application
/// - parameter credentials: User credentials for authentication (if any)
///
/// - returns: SwiftElasticSearch class Object
///
    public init(url : String? = "https://scalr.api.appbase.io", app : String, credentials : String) {
        self.url = url!
        self.app = app
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
    // MARK: - Operations
    
/// Adds given JSON data to the database (POST/PUT request)
///
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of data to be indexed
/// - parameter body: Data that needs to indexed. The data must be in valid JSON format. For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-index_.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-index_.html) Eg :
///
///                     let updateParameters:[String:Any] = [
///                         "year": 2018,
///                          "movieName": "La La Land"
///                 ]
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
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
    
    
/// Fetches data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func get(type: String? = "_doc", id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        APIkey?.getData(url: url, app: app, type: type!, id: id, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Deletes data from the database for the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func delete(type: String? = "_doc", id : String, headers: [String: String]? = nil,completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        APIkey!.deleteData(url: url, app: app, type: type!, id: id, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Update data of the provided unique id (GET request)
///
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter body: Data that needs to updated. The data must be in valid JSON format. Eg :
///
///             let updateParameters: [String:Any] = ["doc": ["year": 2018]]
///
/// While updating, all the JSON body needs to be put inside a doc array as shown above else the method won't work. For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-update.html#_updates_with_a_partial_document)
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func update(type: String? = "_doc", id : String, body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let updateID = id + "/_update"
        
        APIkey!.postData(url: url, app: app, type: type!, id: updateID, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Make bulk requests on a specified app or a specific type. Bulk requests can be any of index, update and delete requests.
///
/// - parameter type: Type of data that is created in the app (should only be passed if you want to make the request to the that perticular type)
/// - parameter body: JSON structured data parameter that has to be passed for updating, Note: For updating data,    the JSON must be of the format [[String:Any]]. A quick example of bulk request is :
///
///             let bulkParameters:[[String:Any]] = [
///                     [ "index": [ "_type": "SwiftClientES"] ],
///                     ["Title" : "New Movie 4" , "Year" : "2016"],
///                     [ "delete" : ["_id": "testID"]]
///             ]
///
/// For more information : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-bulk.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/docs-bulk.html)
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func bulk(type: String? = "_doc", body : [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let bulk = type! + "/_bulk"
        
        APIkey!.bulkData(url: url, app: app, type: bulk, body: body, headers:headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Apply a search via the request body. The request body is constructed using the Query DSL.
///
/// - parameter type: Type of data that is created in the app (should only be passed if you want to make the request to the that perticular type)
/// - parameter body: The request body through which the query has to be made.The request body is constructed using the Query DSL.
/// More information on how to make a request body can be found on : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html)
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func search(type: String? = "_doc", body : [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let msearchType = type! + "/_search"
        
        APIkey!.postData(url: url, app: app, type: msearchType, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }


/// Apply a multiple search via the request body. The individual request bodies are constructed using the Query DSL.
///
/// - parameter type: Type of data that is created in the app (should only be passed if you want to make the request to the that perticular type)
/// - parameter body: The request body through which the query has to be made. Multiple queries can be made by format: [query1(json),query2(json)]. The individual request body is constructed using the Query DSL.
/// More information on how to make a request body can be found on : [https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/query-dsl.html)
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func msearch(type: String? = "_doc", body : [[String : Any]], headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()) {
        
        let msearchType = type! + "/_msearch"
        
        APIkey!.bulkData(url: url, app: app, type: msearchType, body: body,headers: headers) { ( JSON, response, error ) in
            
            completionHandler(JSON, response, error)
        }
    }


/// Get streaming updates to a document with the specified id. The [stream = true] parameter informs the service to keep the connection open, which is used to provide subsequent updates.
///
/// - parameter type: Type of data that is created in the app
/// - parameter id: ID of indexed data
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received message in JSON format having parameters channel - Path where streaming is made and event - The change that is observed
///
    public func getStream(type: String? = "_doc", id: String, headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
        
        getStreamData(url: url, credentials: credentials, app: app, type: type!, id: id) { (message) in
            
            completionHandler(message)
        }
    }
    
    
/// Get streaming updates to a search query provided in the request body. The stream=true parameter informs the appbase.io service to keep the connection open, which is used to provide subsequent updates.
///
/// - parameter type: Type of data that is created in the app
/// - parameter body: Search query of the streaming
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received message in JSON format until the connection is closed
///
    public func searchStream(type: String? = "_doc", body: [String : Any], headers: [String: String]? = nil, completionHandler: @escaping (Any?) -> ()) {
        
        getSearchStreamData(url: url, credentials: credentials, app: app, type: type!, body: body) { (message) in
            
            completionHandler(message)
        }
    }
    
    
/// Provides the data mapping corresponding to the app or the type.
///
/// - parameter type: Type of data that is created in the app (Appbase dashboard), provide if you want to get the data mapping from the correspong type.
/// - parameter header: The additional headers which have to be provided
///
/// - returns: Received data and response in JSON format and the error occured if any in format (Any?, Any?, Error?)
///
    public func getMapping(type: String? = "_doc" , headers: [String: String]? = nil, completionHandler: @escaping (Any?, Any?, Error?) -> ()){
        
        APIkey?.getMapping(url: url, app: app, type: type!, headers: headers) {
            JSON, response, error in
            
            completionHandler(JSON, response, error)
        }
    }
    
    
/// Provides the number of types which you have made
///
/// - parameter header: The additional headers which can be provided if required
///
/// - returns: The number of types in your app.
///
    public func getTypes(headers: [String: String]? = nil) -> Int {
        
        var innerJson:NSDictionary?
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            self.APIkey?.getMapping(url: self.url, app: self.app, headers:headers) {
                JSON, response, error in
                
                innerJson = ((JSON! as? [String:Any])![self.app]! as? [String:Any])!["mappings"]! as? NSDictionary
                group.leave()
            }
        }
        group.wait()
        
        return (innerJson?.count)! - 2
    }
}
