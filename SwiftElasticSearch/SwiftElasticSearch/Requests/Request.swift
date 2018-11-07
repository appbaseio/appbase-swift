//
//  Requests.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

public class Request {
    
    public var credentials : String?
    
    /**
     Inititate parameters of a request that needs to be made
     - Parameters:
         - credentials: Credentials of the user
    */
    public init(credentials : String) {
        self.credentials = credentials
    }
    
    // Type of HTTP Request made
    enum RequestType: String{
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
    
    /**
     Initiate the POST request
     
     - Parameters:
        - type/method: HTTP Request Type
        - target: Server endpoint URL
        - body: Data parameters that needs to send (Can be nil)
        - callBack: Completion Handler of the async network call
    */
    public func postData(type method: String, target: String, body: [String : AnyObject]? , callback: @escaping (Any?, Error?) -> Void) {
        
        let errDomain = "Network Errors"
        let errDescription = "localizedDescription"
        let serializationErrDomain = "JSON Serialization Errors"
        
        var request = URLRequest(url: URL(string: target)!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("credentials", forHTTPHeaderField: self.credentials!)
        
        if body != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body!, options: .prettyPrinted)
            } catch {
                let err = NSError(domain: serializationErrDomain, code: 999, userInfo: [errDescription:NSLocalizedString(errDescription, comment: CommonError.jsonSerialization.rawValue)])
                callback(nil, err)
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil
                else{
                callback(nil, error!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= NetworkError.Success.code{
                
                switch httpStatus.statusCode{
                    
                case NetworkError.Unknown.rawValue:
                    let err = NSError(domain: errDomain, code: NetworkError.Unknown.rawValue, userInfo: [errDescription:NSLocalizedString(errDescription, comment: NetworkError.Unknown.localizedDescription)])
                    callback(nil, err)
                    return
                    
                case NetworkError.NotFound.rawValue:
                    let err = NSError(domain: errDomain, code: NetworkError.NotFound.rawValue, userInfo: [errDescription:NSLocalizedString(errDescription, comment: NetworkError.NotFound.localizedDescription)])
                    callback(nil, err)
                    return
                    
                default:
                    let err = NSError(domain: errDomain, code: httpStatus.statusCode, userInfo: [errDescription:NSLocalizedString(errDescription, comment:CommonError.networkConnection.rawValue)])
                    callback(nil, err)
                    return
                }
            }
            
            let responseString = String(data: data, encoding: .utf8)?.parseJSONString as! String
            callback(responseString, nil)
        }
        
        task.resume()
    }
    
}
