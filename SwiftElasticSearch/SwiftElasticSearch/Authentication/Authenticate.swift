//
//  Authenticate.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 09/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

public class Authenticate {
    
    public let characters : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    public init() {
        
    }
    
    // Generates random string of given length
    func generateRandomString(length : Int) -> String {
        return String((0...length-1).map{ _ in characters.randomElement()! })
    }
    
    // Generates random ID of the following pattern "xxxxxxxx-xxxx-4xxx-xxxx-xxxxxxxxxxxx"
    public func generateRandomID() -> String {
        
        let id = generateRandomString(length: 8) + "-" + generateRandomString(length: 4) + "-4" + generateRandomString(length: 3) + generateRandomString(length: 4) + generateRandomString(length: 12)
        
        return id
    }

}
