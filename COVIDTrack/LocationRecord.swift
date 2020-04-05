//
//  LocationRecord.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

struct LocationRecordKeys {
    static let date = "date"
    static let county = "county"
    static let state = "state"
    static let fips = "fips"
    static let cases = "cases"
    static let deaths = "deaths"
}

class LocationRecord: NSObject, NSCoding {
    var date: Date
    var county: String?
    var state: String
    var fips: String
    var cases: Int
    var deaths: Int
    
    func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: LocationRecordKeys.date)
        coder.encode(self.county ?? "", forKey: LocationRecordKeys.county)
        coder.encode(self.state, forKey: LocationRecordKeys.state)
        coder.encode(self.fips, forKey: LocationRecordKeys.fips)
        coder.encode(self.cases, forKey: LocationRecordKeys.cases)
        coder.encode(self.deaths, forKey: LocationRecordKeys.deaths)
    }
    
    required convenience init?(coder: NSCoder) {
        if let date = coder.decodeObject(forKey: LocationRecordKeys.date) as? Date,
            let county = coder.decodeObject(forKey: LocationRecordKeys.county) as? String,
            let state = coder.decodeObject(forKey: LocationRecordKeys.state) as? String,
            let fips = coder.decodeObject(forKey: LocationRecordKeys.fips) as? String,
            let cases = coder.decodeObject(forKey: LocationRecordKeys.cases) as? Int,
            let deaths = coder.decodeObject(forKey: LocationRecordKeys.deaths) as? Int {
            self.init(date, county, state, fips, cases, deaths)
        } else {
            return nil
        }
    }
    
    init(_ date: Date,_ county: String,_ state: String,_ fips: String,_ cases: Int,_ deaths: Int) {
        self.date = date
        self.county = county
        self.state = state
        self.fips = fips
        self.cases = cases
        self.deaths = deaths
    }
}
