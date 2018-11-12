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
