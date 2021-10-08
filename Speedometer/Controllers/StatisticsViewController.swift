//
//  HistoryViewController.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 01.09.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit
import RealmSwift

class StatisticsViewController: UIViewController {

    @IBOutlet var statisticsLabelCollection: [UILabel]!
    @IBOutlet var containerViewCollection: [UIView]!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var myTripsButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    let realm = try! Realm()
    let manageUI = ManageUI()
    var timeArray = ["0", "0", "0", "0", "0", "0"]
    var maxSpeed = "0"
    var avgSpeed = "0"
    var distance = "0"
    var duration =  "00:00:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in containerViewCollection {
            manageUI.manageContainerView(view)
        }
        manageUI.manageButton(myTripsButton)
        
        maxSpeedLabel.adjustsFontSizeToFitWidth = true
        avgSpeedLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        durationLabel.adjustsFontSizeToFitWidth = true
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
        let speedometerVC = navVC.topViewController as! SpeedometerViewController
        speedometerVC.restTripButton(sender: sender)
    }
    
    func updateUI() {
        if let statisticsLabelCollection = statisticsLabelCollection, let maxSpeedLabel = maxSpeedLabel, let avgSpeedLabel = avgSpeedLabel, let distanceLabel = distanceLabel, let durationLabel = durationLabel {
            
            for label in statisticsLabelCollection {
                label.adjustsFontSizeToFitWidth = true
                label.text = timeArray[label.tag]
            }
            
            maxSpeedLabel.text = maxSpeed
            avgSpeedLabel.text = avgSpeed
            distanceLabel.text = distance
            durationLabel.text = duration
        }
    }
    
    //MARK: - RealmSaveObject
    
    func saveObject() {
        let newTrip = Trip()

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy | HH:mm"
        newTrip.date = formatter.string(from: date)

        newTrip.distance = distance
        newTrip.duration = duration
        newTrip.maxSpeed = maxSpeed
        newTrip.avgSpeed = avgSpeed
        newTrip.firstAccelTime = timeArray[0]
        newTrip.secondAccelTime = timeArray[1]
        newTrip.thirdAccelTime = timeArray[2]
        newTrip.fourthAccelTime = timeArray[3]
        newTrip.fifthAccelTime = timeArray[4]
        newTrip.sixthAccelTime = timeArray[5]

        realm.beginWrite()
        realm.add(newTrip)
        try! realm.commitWrite()
    }

    
}
