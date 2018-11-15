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

}
