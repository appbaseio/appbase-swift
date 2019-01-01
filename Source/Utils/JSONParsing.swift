//
//  JSONParsing.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 06/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

extension String{

/// Parses the string to JSON object
///
/// - returns: JSON object in string.
///
    var parseJSONString : Any? {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data {
            do {
                return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            } catch {
                return nil
            }
        }
        return nil
    }
}


/// Structures JSON query in String format
///
/// - parameter json: JSON query which needs to be converted into String format
/// - parameter prettyPrinted: If this option is not true, the most compact possible JSON representation is generated
///
public func stringify(json: Any, prettyPrinted: Bool = false) -> String {
    var options: JSONSerialization.WritingOptions = []
    
    if prettyPrinted {
        options = JSONSerialization.WritingOptions.prettyPrinted
    }
    
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch {
        print(error)
    }
    
    return ""
}
