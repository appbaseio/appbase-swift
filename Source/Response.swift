//
//  Response.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

/// This class handles the responses that are received from the server when any request is made. It also handles any error while receiving the response.
///
public class Response {
    
    // MARK: - Properties
    
    public let data: Data?
    public let httpResponse: URLResponse?
    public let error: Error?
   
    
    // MARK: - Initializer

/// Initialises the Response class by providing the parameters as received response from the server
///
/// - parameter data: Data that is received for the request made
/// - parameter httpResponse: Response received from the server
/// - parameter error: Error(if any) that is encountered
///
    public init(data: Data? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
    
    public func getReceivedData() -> Any? {

        if let data = data {
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return json
            } catch {
                // Handle error
            }
        }
        
        return nil
    }
    
    public func getStatusCode() -> Int {
        
        let response = self.httpResponse as! HTTPURLResponse
        let statusCode = response.statusCode
        
        return statusCode
    }
    
    public func getReceivedError() -> Error? {
        return error
    }
    
    public func isDataReceieved() -> Bool {
        
        let response = self.httpResponse as! HTTPURLResponse
        let statusCode = response.statusCode
        
        let status = Errors.init(statusCode: statusCode)
        
        return status.isSuccess()
    }
    
    public func getReceivedStatusFromCode() -> String {
        
        let response = self.httpResponse as! HTTPURLResponse
        let statusCode = response.statusCode
        
        let error = Errors.init(statusCode: statusCode)
        
        return error.getErrorFromCode()
    }
}
