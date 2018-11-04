//
//  Requests.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

public protocol Request {
    
    var method: HTTPMethod { get }
    
    var endPoint: String { get }
    
    var body: Data { get }
    
    func execute() -> Void
    
}

public class Response<T: Codable> {
    
    public let data: T?
    public let httpResponse: URLResponse?
    public let error: Error?
    
    init(data: T? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
}


public protocol RequestBuilder {
    
    func build() throws -> Request
}

