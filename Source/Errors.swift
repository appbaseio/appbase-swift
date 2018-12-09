//
//  Errors.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

    // MARK: Operators

/// Enum holding status codes for corresponding error messages
///

public class Errors {
    
    public let statusCode : Int
    
    public init(statusCode : Int) {
        self.statusCode = statusCode
    }
    
    public func getErrorFromCode() -> String {
        
        switch statusCode {
            
        /// Success
        case 200:
            return "OK"
            
        /// Invalid parameters / Invalid Credentials
        case 400:
            return "Bad Request"
            
        /// Invalid authentication.
        case 401:
            return "Unauthorized"
            
        /// Operation unauthorized with the provided credentials.
        case 403:
            return "Forbidden"
            
        /// The targeted resource does not exist.
        case 404:
            return "Not Found"
            
        /// The server has encountered a fatal internal error.
        case 500:
            return "Internal Server Error"
            
        /// The server is temporarily down.
        case 503:
            return "Service Unavailable"
            
        /// Unknown Error occured
        default:
            return "Unknown Error"
        }
    }

    /// Test whether a status code represents success
    public func isSuccess() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

    /// Test whether a status code represents a client error
    public func isClientError() -> Bool {
        return statusCode >= 400 && statusCode < 500
    }

    /// Test whether a status code represents a server error
    public func isServerError() -> Bool {
        return statusCode >= 500 && statusCode < 600
    }

    /// Test whether a status code represents bad credential
    public func isBadCredential() -> Bool {
        return statusCode == 401
    }

    /// Test whether a status code represents page doesn't exist
    public func isNotFound() -> Bool {
        return statusCode == 404
    }

/// Common Errors like Serialization Errors etc.
///
public enum CommonError: String {
    
    /// JSON body parsing error
    case jsonSerialization = "Couldn't parse to/from json object."
    
    /// Network Connection error
    case networkConnection = "Network error."
 
    }
}
