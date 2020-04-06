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
    var groups: [LocationGroup] = []
    
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
            self.groups = groups
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedGroup = self.groups[indexPath.row]
        if AppManager.storage.isWatched(selectedGroup) {
            print("removing group")
            AppManager.storage.removeGroup(selectedGroup)
        } else {
            print("adding group")
            AppManager.storage.addGroup(selectedGroup)
        }
        // self.tableLocations.dequeueReusableCell(withIdentifier: selectedGroup.title)?.detailTextLabel?.text = selectedGroup.info()
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic) //try other animations
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = self.groups[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: group.title) {
            return cell
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: group.title)
        cell.textLabel?.text = group.title
        cell.detailTextLabel?.text = group.info()
        return cell
    }
}

