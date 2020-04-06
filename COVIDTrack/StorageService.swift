//
//  StorageManager.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

class StorageService {
    private var _watchedGroups: [LocationGroup]?
    func getWatchedGroups()->[LocationGroup] {
        if let watchedGroups = self._watchedGroups {
            return watchedGroups
        }
        let watchedGroups = NSKeyedUnarchiver.unarchiveObject(withFile: self.watchedGroupsURL.path) as? [LocationGroup]
        self._watchedGroups = watchedGroups
        return watchedGroups ?? []
    }

    func addGroup(_ group: LocationGroup) {
        var watchedGroups = self.getWatchedGroups()
        watchedGroups.append(group)
        self._watchedGroups = watchedGroups
        let res = NSKeyedArchiver.archiveRootObject(watchedGroups, toFile: self.watchedGroupsURL.path)
        print(res)
    }

    func removeGroup(_ group: LocationGroup) {
        var watchedGroups = self.getWatchedGroups()
        var i = 0
        for watchGroup in watchedGroups {
            if group.title == watchGroup.title {
                watchedGroups.remove(at: i)
                self._watchedGroups = watchedGroups
                NSKeyedArchiver.archiveRootObject(watchedGroups, toFile: self.watchedGroupsURL.path)
                return
            }
            i += 1
        }
    }

    func isWatched(_ group: LocationGroup)->Bool {
        let watchedGroups = self.getWatchedGroups()
        for watchGroup in watchedGroups {
            if watchGroup.title == group.title {
                return true
            }
        }
        return false
    }

    private var _watchedGroupsURL: URL?
    var watchedGroupsURL: URL {
        if let watchedGroupsURL = self._watchedGroupsURL {
            return watchedGroupsURL
        }
        let url = self.documents.appendingPathComponent("WatchedGroups")
        self._watchedGroupsURL = url
        return url
    }

    private var _documents: URL?
    var documents: URL {
        if let documents = self._documents {
            return documents
        }
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        self._documents = url[0]
        return url[0]
    }
}
