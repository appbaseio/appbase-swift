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
    
    let data: Data?
    let httpResponse: URLResponse?
    let error: Error?
    
    public init(data: Data? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
}

class GetResponse<T: Codable>: Codable {
    
    var index: String?
    var type: String?
    var id: String?
    var version: Int?
    var found: Bool?
    
    public var source: T?
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
        
        case found
    }
}

public class Hits<T: Codable>: Codable {
    
    public var total: Int?
    public var maxScore: Double?
    public var hits: [SearchHit<T>] = []
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }
    
}

public class SearchHit<T: Codable>: Codable {
    
    var index: String?
    var type: String?
    var id: String?
    var score: Double?
    var source: T?
    
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
    }
}
