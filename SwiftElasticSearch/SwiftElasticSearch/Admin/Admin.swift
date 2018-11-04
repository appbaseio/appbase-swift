//
//  Admin.swift
//  SwiftElasticSearch
//
//  Created by Harsh Patel on 04/11/18.
//  Copyright © 2018 Harsh Patel. All rights reserved.
//

import Foundation

internal class Admin: ESClient {
    
    func indices() -> IndiciesAdmin {
        return IndiciesAdmin(withClient: self)
    }
    
    func cluster() -> ClusterAdmin {
        return ClusterAdmin(withClient: self)
    }
    
}
