//
//  Authenticate.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 09/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

/// Used for authenticating app and type properties used in Client.swift class
///
public class Authenticate {
    
    /// A string consisting of all the alphanumeric and some special characters
    ///
    let characters : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    
    /// init: initialiser of the Authenticate class
    ///
    public init() {
        
    }
    
    /// generateRandomString: Generates random string of given length
    ///
    /// - parameter length: Length of the string that is to be generated
    ///
    /// - returns: String of random characters of given length
    ///
    func generateRandomString(length : Int) -> String {
        return String((0...length-1).map{ _ in characters.randomElement()! })
    }
    
    /// generateRandomID : Generates random ID of the following pattern "xxxxxxxx-xxxx-4xxx-xxxx-xxxxxxxxxxxx"
    ///
    /// - returns: A random ID having a pattern followed by Appbase
    ///
    func generateRandomID() -> String {
        
        let id = generateRandomString(length: 8) + "-" + generateRandomString(length: 4) + "-4" + generateRandomString(length: 3) + generateRandomString(length: 4) + generateRandomString(length: 12)
        
        return id
    }

}
