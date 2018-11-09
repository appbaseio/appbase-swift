//
//  SwiftElasticSearch.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public class SwiftElasticSearch : NSObject {
    
    public var baseURL : String
    public var appName : String
    public var credentials : String
    public var APIkey : Request?
    public let util = Utils()
    
    /**
     Creates an Elastic Search class object for Appbase
     - Parameters:
        - url: URL of the server (If application is hosted on Appbase, url should be scalr.api.appbase.io)
        - appID: Name of the application
        - credentials: User credentials for authentication (Read Key)
     
     - Returns: SwiftElasticSearch class Object
     */
    
    public init(url baseURL : String, appName : String, credentials : String) {
        self.baseURL = baseURL
        self.appName = appName
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
    
    /**
     Creates an Elastic Search class object for Appbase
     - Parameters:
        - type: Type of data that is created in the app (Appbase dashboard)
        - id: ID of query (Can be nil)
        - body: Data parameters that needs to send (Can be nil)
    */
    public func index(type: String, id : String?, body : [String : AnyObject]?) {
  
        var method = util.getRequestType(RequestString: "POST")
        if id != nil {
            method = util.getRequestType(RequestString: "PUT")
        }
            
        APIkey!.postData(url: baseURL, type: type, method: method, appName: appName, id: id, body: body)
    }
}
