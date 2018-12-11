//
//  SwiftElasticSearchTests.swift
//  SwiftElasticSearchTests
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import XCTest
@testable import SwiftElasticSearch

class SwiftElasticSearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func test_index_is_created() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            client.index(type: "SwiftClientES", id: nil, body: ["title" : "movie"]) { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 201)
                
                group.leave()
            }

        }
        
        group.wait()
        
    }
    
    func test_get_is_true() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            client.get(type: "SwiftClientES", id: "AWbvtQKGUHDq8oqypAHx", completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
            
        }
        
        group.wait()
    }
    
    func test_delete_is_deleted() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            client.delete(type: "SwiftClientES", id: "AWbvtMgpUHDq8oqyo_Vx", completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
            
        }
        
        group.wait()
    }
    
    func test_update_is_updated() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            let updateParameters:[String:Any] = [
                                        "doc": [
                                            "year": 2018
                                            ]
                                        ]
            
            client.update(type: "SwiftClientES", id: "AWbvtPuIUHDq8oqypACI", body: updateParameters, completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
            
        }
        
        group.wait()
    }
    
}
