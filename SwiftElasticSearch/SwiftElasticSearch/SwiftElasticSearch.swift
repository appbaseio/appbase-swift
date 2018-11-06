//
//  SwiftElasticSearch.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

public class SwiftElasticSearch : NSObject {
    
    var baseURL : String?
    var appID : String?
    var credentials : String?
    var APIkey : Request?
    
    /**
     Creates an Elastic Search class object for Appbase
     - Parameters:
        - url: URL of the server
        - appID: Name of the application
        - credentials: User credentials for authentication
     
     - Returns: SwiftElasticSearch class Object
     */
    
    init(url baseURL : String, appID : String, credentials : String) {
        self.baseURL = baseURL
        self.appID = appID
        self.credentials = credentials
        self.APIkey = Request(credentials : credentials)
    }
    
    func index(type : String, id : String?, body : [String : AnyObject], completionHandler : @escaping (Any?, Error?) -> Void) {
        
        var endpoint = type
        var method = API.RequestType.POST.rawValue
        if id != nil {
            method = API.RequestType.PUT.rawValue
            endpoint += "/" + id!
        }
        
        APIkey!.initiate(type: method, target: endpoint, body: body, callback: { (response, error) in
            guard error == nil else{
                completionHandler(nil, error)
                return
            }
            guard response == nil else{
                completionHandler(response, nil)
                return
            }
        })
    }    
}
