//
//  AppManager.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

class AppManager {
    static let api = ApiService()
    static let storage = StorageService()

    static func checkWatchedGroups(_ completion: @escaping (Error?, Int, String, [LocationGroup])->()) {
        let watchedGroups = storage.getWatchedGroups()

        api.checkStates() { error, groups in
            var count = 0
            var message = ""
            for group in groups {
                for watchedGroup in watchedGroups {
                    if watchedGroup.title == group.title,
                        watchedGroup.deaths != group.deaths || watchedGroup.cases != group.cases {
                        count += 1
                        let deathDiff = group.deaths - watchedGroup.deaths
                        let casesDiff = group.cases - watchedGroup.cases
                        message += "\(deathDiff > 0 ? (String(deathDiff) + " new fatalities " + (casesDiff > 0 ? " and " : "")) : "")\(casesDiff > 0 ? (String(casesDiff) + " new cases "): "") for \(watchedGroup.title)\(groups.last == group ? "" : ", ")"
                    }
                }
            }
            completion(error, count, message, groups)
        }
    }
}
