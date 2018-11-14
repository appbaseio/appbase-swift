//
//  Errors.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

class ElasticsearchError: Error, Codable {
    
    var error: ElasticError?
    var status: Int?
    
    /// Initialiser of Error class
    init() {}
}

class ElasticError: Codable {
    
    var type: String?
    var index: String?
    var shard: String?
    var reason: String?
    var indexUUID: String?
    var rootCause: [ElasticError]?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case rootCause = "root_cause"
        case indexUUID = "index_uuid"
        case shard
        case index
        case reason
        case type
    }
}

/// Standard HTTP Errors
///
public struct HTTPError: CustomNSError {
    
    // MARK: - Properties
    
    public let statusCode: Int
    public let message: String?
    
    // MARK: Initializer
    
    /// Initialize the HTTP Error
    ///
    /// - parameter statusCode: The code that is used to identify the error
    /// - parameter message: The server message that is obtained
    ///
    public init(statusCode: Int, message: String? = nil) {
        self.statusCode = statusCode
        self.message = message
    }
    
    public var errorCode: Int { return statusCode }
    
    public var errorUserInfo: [String: Any] {
        var userInfo = [String: Any]()
        if let message = message {
            userInfo[NSLocalizedDescriptionKey] = message
        }
        return userInfo
    }
}


    // MARK: Operators

/// Enum holding status codes for corresponding error messages
///
public enum StatusCode: Int {

    /// Success
    case ok = 200
    
    /// Invalid parameters
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
        return statusCode >= 200 && statusCode < 300
    }
    
    /// Test whether a status code represents a client error
    public static func isClientError(_ statusCode: Int) -> Bool {
        return statusCode >= 400 && statusCode < 500
    }
    
    /// Test whether a status code represents a server error
    public static func isServerError(_ statusCode: Int) -> Bool {
        return statusCode >= 500 && statusCode < 600
    }
}
