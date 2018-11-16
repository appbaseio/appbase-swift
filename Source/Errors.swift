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
public enum StatusCode: Int {

    /// Success
    case ok = 200
    
    /// Invalid parameters / Invalid Credentials
    case badRequest = 400
    
    /// Invalid authentication.
    case unauthorized = 401
    
    /// Operation unauthorized with the provided credentials.
    case forbidden = 403
    
    /// The targeted resource does not exist.
    case notFound = 404
    
    /// The server has encountered a fatal internal error.
    case internalServerError = 500
    
    /// The server is temporarily down.
    case serviceUnavailable = 503
    
    /// Test whether a status code represents success
    public static func isSuccess(_ statusCode: Int) -> Bool {
        return statusCode == 200
    }
    
    /// Test whether a status code represents a client error
    public static func isClientError(_ statusCode: Int) -> Bool {
        return statusCode >= 400 && statusCode < 500
    }
    
    /// Test whether a status code represents a server error
    public static func isServerError(_ statusCode: Int) -> Bool {
        return statusCode >= 500 && statusCode < 600
    }
    
    /// Test whether a status code represents bad credential
    public static func isBadCredential(_ statusCode: Int) -> Bool {
        return statusCode == 401
    }
    
    /// Test whether a status code represents page doesn't exist
    public static func isNotFound(_ statusCode: Int) -> Bool {
        return statusCode == 404
    }
}

/// Common Errors like Serialization Errors etc.
///
public enum CommonError: String {
    
    /// JSON body parsing error
    case jsonSerialization = "Couldn't parse to/from json object."
    
    /// Network Connection error
    case networkConnection = "Network error."
 
}
