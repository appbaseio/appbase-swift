//
//  API.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 05/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import Alamofire

class Utils {
    
    /// init: Initialiser of the utility class
    ///
    init() {
        
    }
    
    /// Helper Enum holding corresponding value of HTTP Request types
    ///
    let RequestTypes: [(RequestString: String, HTTPvalue: HTTPMethod)] = [("GET", .get), ("POST", .post), ("PUT", .put), ("DELETE", .delete)]
    
    
    /// getRequestType: Return the HTTP Request type for the given request message
    ///
    /// - parameter RequestString: Request message
    ///
    /// - returns: HTTP Request method
    ///
    func getRequestType(RequestString: String) -> HTTPMethod{
        let method = RequestTypes.first(where: { $0.RequestString ==  RequestString} )?.HTTPvalue
        return method!
    }
    
    /// Network Errors with descriptions
    ///
    public enum NetworkError: Int, Error{
        case Success = 200
        case Unknown = 400
        case NotFound = 500
        
        var localizedDescription: String{
            switch self{
                
            /// Success
            case .Success:
                return "Success"
                
            /// Unknown request
            case .Unknown:
                return "Bad request, couldn't parse the request."
                
            /// Request not found
            case .NotFound:
                return "Server not found, please try again."
            }
        }
        var code: Int{ return self.rawValue}
    }
    
    /// Common Errors like Serialization Errors etc.
    ///
    public enum CommonError: String{
        
        /// JSON body parsing error
        case jsonSerialization = "Couldn't parse to/from json object."
        
        /// Network Connection error
        case networkConnection = "Network error."
    }
}
