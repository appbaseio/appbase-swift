//
//  API.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 05/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

class API : NSObject {
    
    public var credentials : String?
    
   public init(credentials : String) {
        self.credentials = credentials
    }
    
    /**
     Helper Enum holding corresponding String value of HTTP Request types
     */
    public enum RequestType: String {
        case OPTIONS = "OPTIONS"
        case GET     = "GET"
        case HEAD    = "HEAD"
        case POST    = "POST"
        case PUT     = "PUT"
        case PATCH   = "PATCH"
        case DELETE  = "DELETE"
        case TRACE   = "TRACE"
        case CONNECT = "CONNECT"
    }
    
    // Network Errors with descriptions
    enum NetworkError: Int, Error{
        case Success = 200
        case Unknown = 400
        case NotFound = 500
        
        var localizedDescription: String{
            switch self{
            case .Success:
                return "Success"
            case .Unknown:
                return "Bad request, couldn't parse the request."
            case .NotFound:
                return "Server not found, please try again."
            }
        }
        var code: Int{ return self.rawValue}
    }
    
    // Common Errors like Serialization Errors etc.
    enum CommonError: String{
        case jsonSerialization = "Couldn't parse to/from json object."
        case networkConnection = "Network error."
    }
}
