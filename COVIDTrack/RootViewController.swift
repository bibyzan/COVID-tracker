//
//  ViewController.swift
//  COVIDTrack
//
//  Created by Bennett Rasmussen on 4/5/20.
//  Copyright © 2020 ben. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var segmentGeo = UISegmentedControl()
    var tableLocations = UITableView()
    var records: [LocationRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentGeo.addTarget(self, action: #selector(self.segmentGeoDidChange(_:)), for: .valueChanged)
        self.tableLocations.delegate = self
        self.tableLocations.dataSource = self
        
        self.view.addSubview(tableLocations)
        
        AppManager.api.checkStates() { error, records in
            if let error = error {
                print(error)
            }
            var dic: [String: LocationRecord] = [:]
            for record in records {
                if let existingRecord = dic[record.state] {
                    if existingRecord != record && record.date.timeIntervalSinceNow < existingRecord.date.timeIntervalSinceNow {
                        dic[record.state] = record
                    }
                } else {
                    dic[record.state] = record
                }
            }
            var filteredRecords: [LocationRecord] = []
            for val in dic.values {
                filteredRecords.append(val)
            }
            self.records = filteredRecords
            DispatchQueue.main.async {
                self.tableLocations.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableLocations.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50)
    }

    @objc func segmentGeoDidChange(_ sender: UISegmentedControl) {
        print("segment changed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = self.records[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: record.description) {
            return cell
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: record.description)
        cell.textLabel?.text = record.state
        cell.detailTextLabel?.text = "cases: \(record.cases) deaths: \(record.deaths)"
        return cell
    }
}

