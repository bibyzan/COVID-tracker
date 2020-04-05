//
//  LocationGroup.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

class LocationGroup {
    var title: String
    var records: [LocationRecord]
    
    init(_ title: String, _ records: [LocationRecord]) {
        self.title = title
        self.records = records
    }
}
