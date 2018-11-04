//
//  Serialization.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

class Serializers {
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    public static func decode<T: Codable>(data: Data) throws -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    public static func encode<T: Codable>(_ value: T) throws -> Data? {
        do {
            return try encoder.encode(value)
        } catch {
            throw error
        }
    }
}
