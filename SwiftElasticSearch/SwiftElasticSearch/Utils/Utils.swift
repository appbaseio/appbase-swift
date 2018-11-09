//
//  API.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 05/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import Alamofire

public class Utils {
    
    public init() {
        
    }
    
    /**
     Helper Enum holding corresponding value of HTTP Request types
     */
    public let RequestTypes: [(RequestString: String, HTTPvalue: HTTPMethod)] = [("GET", .get), ("POST", .post), ("PUT", .put), ("DELETE", .delete)]
    
    public func getRequestType(RequestString: String) -> HTTPMethod{
        let method = RequestTypes.first(where: { $0.RequestString ==  RequestString} )?.HTTPvalue
        return method!
    }
    
    // Network Errors with descriptions
    public enum NetworkError: Int, Error{
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
    public enum CommonError: String{
        case jsonSerialization = "Couldn't parse to/from json object."
        case networkConnection = "Network error."
    }
}
