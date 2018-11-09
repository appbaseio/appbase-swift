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

public class Request {
    
    public var credentials : String
    public let authenticate = Authenticate()
    
    /**
     Inititate parameters of a request that needs to be made
     - Parameters:
         - credentials: Credentials of the user
    */
    public init(credentials : String) {
        self.credentials = credentials
    }
    
    /**
     Initiate the POST request
     
     - Parameters:
        - url: Server endpoint URL
        - type: Type of data that is created in the app (Appbase dashboard)
        - method: Type of request
        - appName: Name of application
        - id: ID of query (Can be nil)
        - body: Data parameters that needs to send (Can be nil)
    */
    public func postData(url: String, type: String, method: HTTPMethod, appName: String, id: String?, body: [String : AnyObject]?) {

        var requestURL = "https://" + credentials + "@" + url + "/" + appName + "/" + type
        
        if id != nil {
            requestURL = requestURL + "/" + id!
        }
        
        Alamofire.request(requestURL, method: method, parameters: body, encoding: JSONEncoding.default).responseJSON {  (response) in
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
    
}
