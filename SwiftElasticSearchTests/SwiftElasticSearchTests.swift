//
//  SwiftElasticSearchTests.swift
//  SwiftElasticSearchTests
//
//  Created by Harsh Patel And Abhinav Raj on 04/11/18.
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
            
            client.index(type: "SwiftClientES", id: "testID", body: ["title" : "movie"]) { (json, response, error) in
                
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
            
            client.get(type: "SwiftClientES", id: "testID", completionHandler: { (json, response, error) in
                
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
            
            client.delete(type: "SwiftClientES", id: "testID", completionHandler: { (json, response, error) in
                
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
            
            client.update(type: "SwiftClientES", id: "testID", body: updateParameters, completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
            
        }
        
        group.wait()
    }
    
    func test_bulk_is_posted() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            let bulkParameters: [[String:Any]] = [[ "index": [ "_type": "SwiftClientES"] ], [ "Title" : "New Movie 4" , "Year" : "2016"],
                                                  [ "delete" : ["_id": "testID"]]]
            
            client.bulk(type: "SwiftClientES", body: bulkParameters, completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
            
        }
        
        group.wait()
    }
    
    func test_search_is_Searched() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            let body:[String:Any] = [
                "query": [
                    "match": [
                        "title": "The Young Messiah"
                    ]
                ]
            ]
            
            client.search(type: "SwiftClientES", body: body,completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
        }
        group.wait()
    }
    
    func test_msearch_is_Searched() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            let body:[[String:Any]] = [
                [
                    "query": [
                        "match": [
                            "title": "The Young Messiah"
                        ]
                    ]
                ],
                [
                    "query": [
                        "match": [
                            "title": "ABCD"
                        ]
                    ]
                ]
            ]
            
            client.msearch(type: "SwiftClientES", body: body,completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
        }
        group.wait()
    }
    
    func test_getStream_is_working() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            client.getStream(type: "SwiftClientES", id: "testID",completionHandler: { (message) in
                
                let httpResponse = message as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
        }
        group.wait()
    }
    
    func test_searchStream_is_working() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            let body:[String:Any] = [
                "query": [
                    "match": [
                        "title": "The Young Messiah"
                    ]
                ]
            ]
            
            client.searchStream(type: "SwiftClientES", body:body,completionHandler: { (message) in
                
                let httpResponse = message as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
        }
        group.wait()
    }
    
    func test_getMapping_is_working() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            client.getMapping(type: "SwiftClientES",completionHandler: { (json, response, error) in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                XCTAssert(statusCode == 200)
                
                group.leave()
            })
        }
        group.wait()
    }
    
    func test_getTypes_is_working() {
        
        let client = Client.init(url: "https://scalr.api.appbase.io", app: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            
            XCTAssert(client.getTypes() == 6)
            group.leave()
        
        }
        group.wait()
    }
}
