//
//  Requests.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/// Class to handle the GET, POST PUT and DELETE requests made from any class inside the library
///
public class Request {
    
    var credentials : String
    let authenticate = Authenticate()
    
    
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
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter method: Type of request
/// - parameter appName: Name of application
/// - parameter id: ID of query (Can be nil)
/// - parameter body: Data parameters that needs to send (Can be nil)
///
/// - returns: Void
///
    public func postData(url: String, type: String, method: HTTPMethod, appName: String, id: String? = nil, body: [String : Any]? = nil) {

        var requestURL = url + "/" + appName + "/" + type
        let data = (credentials).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + credentials64,
            "Content-Type": "application/json"
        ]
        
        if id != nil {
            requestURL = requestURL + "/" + id!
        }
        
        Alamofire.request(requestURL, method: method, parameters: body, encoding: JSONEncoding.default, headers:headers).responseJSON {  (response) in
                switch response.result {
                    case .success(let JSON2):
                        print("Success with JSON: \(JSON2)")
                        break
            
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        //callback(response.result.value as? NSMutableDictionary,error as NSError?)
                        break
                    }
                }
                .responseString { response in
                        print("Response String: \(String(describing: response.result.value))")
                }
    }
    
    
/// Initiate the GET request
///
/// - parameter url: Server endpoint URL
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter appName: Name of application
/// - parameter id: ID of query
///
/// - returns: JSON object in format [String : Any]?
///
    public func getData(url: String, type: String, appName: String, id: String, completionHandler: @escaping ([String : Any]?, Error?) -> ()) {
        
        let requestURL = url + "/" + appName + "/" + type + "/" + id
        let data = (credentials).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + credentials64,
            "Content-Type": "application/json"
        ]

        Alamofire.request(requestURL,headers:headers)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    completionHandler(nil,response.result.error!)
                    return
                }
                
                // Check to see if returned data is in JSON format
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                        completionHandler(nil, error)
                    }
                    return
                }
                
                completionHandler(json, nil)
        }
    }
    
    
/// Initiate the DELETE request
///
/// - parameter url: Server endpoint URL
/// - parameter type: Type of data that is created in the app (Appbase dashboard)
/// - parameter appName: Name of application
/// - parameter id: ID of query
///
/// - returns: Void
///
    public func deleteData(url: String, type: String, method: HTTPMethod, appName: String, id: String) {
        
        let requestURL = url + "/" + appName + "/" + type + "/" + id
        let data = (credentials).data(using: String.Encoding.utf8)
        let credentials64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + credentials64,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL,method: .delete,headers:headers)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling DELETE")
                    print(response.result.error!)
                    return
                }
                print("Succesfully deleted")
        }
    }
    
}
