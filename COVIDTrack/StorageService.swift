//
//  StorageManager.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

class StorageService {
    static let defaults = UserDefaults.standard
    
    
    
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
