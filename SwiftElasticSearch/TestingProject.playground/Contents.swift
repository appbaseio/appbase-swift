import UIKit
import Foundation
import SwiftElasticSearch

let swiftAPI = SwiftElasticSearch(url: "https://scalr.api.appbase.io", appID: "SwiftClientES", credentials: "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b")

let jsonData:[String:AnyObject] = [
    "title": "Aandhadhun" as AnyObject,
    "year": 2018 as AnyObject,
    "cast": [
    "Aayushman khurrana",
    "Rahika Aapte",
    ] as AnyObject,
    "genres": [
    "Thriller"
    ] as AnyObject
]

swiftAPI.index(type: "SwiftClientES", id: nil, body: jsonData)
