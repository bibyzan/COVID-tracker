//
//  LocationGroup.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

struct LocationGroupKeys {
    static let title = "title"
    static let records = "records"
}

class LocationGroup: NSObject, NSCoding {
    var title: String
    var records: [LocationRecord]
    
    init(_ title: String, _ records: [LocationRecord]) {
        self.title = title
        self.records = records
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: LocationGroupKeys.title)
        coder.encode(self.records, forKey: LocationGroupKeys.records)
    }

    required convenience init?(coder: NSCoder) {
        if let title = coder.decodeObject(forKey: LocationGroupKeys.title) as? String,
           let records = coder.decodeObject(forKey: LocationGroupKeys.records) as? [LocationRecord] {
            self.init(title, records)
        } else {
            print("coder init failed")
            return nil
        }
    }

    func info()->String {
        return "cases: \(self.cases) deaths: \(self.deaths) \(AppManager.storage.isWatched(self) ? "👀" : "")"
    }

    var cases: Int {
        var cases = 0
        for record in records {
            cases += record.cases
        }
        return cases
    }

    var deaths: Int {
        var deaths = 0
        for record in records {
            deaths += record.deaths
        }
        return deaths
    }
}
