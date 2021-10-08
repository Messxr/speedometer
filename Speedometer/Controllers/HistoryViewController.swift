//
//  SavedTripViewController.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 25.02.2021.
//  Copyright © 2021 Daniil Marusenko. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {

    @IBOutlet var statisticsLabelCollection: [UILabel]!
    @IBOutlet var containerViewCollection: [UIView]!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let manageUI = ManageUI()
    let realm = try! Realm()
    var dateString: String?
    var delegate: TripsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in containerViewCollection {
            manageUI.manageContainerView(view)
        }
        
        maxSpeedLabel.adjustsFontSizeToFitWidth = true
        avgSpeedLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        durationLabel.adjustsFontSizeToFitWidth = true
        
        getStatistics()
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let trips = realm.objects(Trip.self)
        for trip in trips {
            if let date = dateString {
                if date == trip.date {
                    try! realm.write {
                        realm.delete(trip)
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: {
            self.delegate?.getObjects()
        })
        
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getStatistics() {
        
        if let dateString = dateString {
            
            let trips = realm.objects(Trip.self)
            for trip in trips {
                if trip.date == dateString {
                    
                    let timeArray = [trip.firstAccelTime, trip.secondAccelTime, trip.thirdAccelTime, trip.fourthAccelTime, trip.fifthAccelTime, trip.sixthAccelTime]
                    
                    for label in statisticsLabelCollection {
                        label.adjustsFontSizeToFitWidth = true
                        label.text = timeArray[label.tag]
                    }
                    
                    maxSpeedLabel.text = trip.maxSpeed
                    avgSpeedLabel.text = trip.avgSpeed
                    distanceLabel.text = trip.distance
                    durationLabel.text = trip.duration
                    
                    dateLabel.text = dateString
                }
            }
            
        }
        
    }
    
}
