//
//  TripsViewController.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 18.02.2021.
//  Copyright © 2021 Daniil Marusenko. All rights reserved.
//

import UIKit
import RealmSwift

class TripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var tripsArray = [Trip]()
    var dateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getObjects()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getObjects() {
        tripsArray = []
        let trips = realm.objects(Trip.self)
        for trip in trips {
            tripsArray.append(trip)
        }
        tripsArray.reverse()
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource

extension TripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TripsTableViewCell
        cell.dateLabel.text = tripsArray[indexPath.row].date
        cell.distanceLabel.text = tripsArray[indexPath.row].distance
        cell.durationLabel.text = tripsArray[indexPath.row].duration
        cell.speedLabel.text = tripsArray[indexPath.row].maxSpeed
        return cell
    }
    
}

//MARK: - UITableViewDelegeta

extension TripsViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripsToHistory" {
            let destVC = segue.destination as! HistoryViewController
            destVC.dateString = dateString
            destVC.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dateString = tripsArray[indexPath.row].date
        performSegue(withIdentifier: "tripsToHistory", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
