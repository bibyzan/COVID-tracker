//
//  ApiService.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import Foundation

enum COVIDApiError: Error {
    case dataParsingFailed
}

class ApiService {
    static let rawCSVBaseUrl = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/"
    
    private func sendGet(to endpoint: String,_ completion: @escaping (Error?, [LocationGroup])->()) {
        let url = URL(string: endpoint)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(error, [])
            } else {
                if let data = data {
                    var records: [LocationRecord] = []
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)?.components(separatedBy: "\n") ?? []
                    for s in dataString {
                        if s == dataString[0] {
                            continue
                        }
                        if let record = LocationRecord(csvStr: s) {
                            records.append(record)
                        } else {
                            print("record \(s) parsing failed")
                        }
                    }
                    var dic: [String: LocationGroup] = [:]
                    for record in records {
                        if let existingGroup = dic[record.state] {
                            existingGroup.records.append(record)
                        } else {
                            dic[record.state] = LocationGroup(record.state, [record])
                        }
                    }
                    var groups: [LocationGroup] = []
                    for group in dic.values {
                        groups.append(group)
                    }
                    completion(nil, groups)
                } else {
                    completion(COVIDApiError.dataParsingFailed, [])
                }
            }
        }
        task.resume()
    }
    
    func checkStates(_ completion: @escaping (Error?, [LocationGroup])->()) {
        self.sendGet(to: ApiService.rawCSVBaseUrl + "us-states.csv", completion)
    }
    
    func checkCounties(_ completion: @escaping (Error?, [LocationGroup])->()) {
        self.sendGet(to: ApiService.rawCSVBaseUrl + "us-counties.csv", completion)
    }
}
