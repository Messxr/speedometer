//
//  SpeedometerViewController.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 01.09.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit
import CoreLocation
import LMGaugeViewSwift
import RealmSwift

class SpeedometerViewController: UIViewController, CLLocationManagerDelegate, GaugeViewDelegate {

    //MARK: IBoutlets
    @IBOutlet weak var gaugeView: GaugeView!
    @IBOutlet weak var headingDisplay: UILabel!
    @IBOutlet weak var distanceTraveled: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hudSpeedLabel: UILabel!
    @IBOutlet weak var hudMeasureLabel: UILabel!
    
    //MARK: Global Var's
    let realm = try! Realm()
    let manageUI = ManageUI()
    var locationManager: CLLocationManager = CLLocationManager()
    var switchSpeed = "KPH"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    
    var speed: CLLocationSpeed?
    var direction: CLLocationDirection?
    
    var traveledDistance: Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []
    var timer: Timer?
    var counter = 0.0
    var extraCounter: Double?
    var timeArray = ["0 sec.", "0 sec.", "0 sec.", "0 sec.", "0 sec.", "0 sec."]
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15, *) {
            let tabBarAppearence = UITabBarAppearance()
            tabBarAppearence.configureWithOpaqueBackground()
            tabBarAppearence.backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            tabBarController?.tabBar.standardAppearance = tabBarAppearence
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearence
        }
            
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 20), NSAttributedString.Key.foregroundColor:UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        let normalFont = UIFont.systemFont(ofSize: 18)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        
        hudMeasureLabel.adjustsFontSizeToFitWidth = true
        
        manageUI.manageContainerView(containerView)
        
        hudSpeedLabel.textColor = .white
        hudSpeedLabel.isHidden = true
        hudSpeedLabel.adjustsFontSizeToFitWidth = true
        hudSpeedLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        hudMeasureLabel.textColor = .white
        hudMeasureLabel.isHidden = true
        hudMeasureLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        // Configure gauge view
        let screenMinSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let ratio = Double(screenMinSize)/320
        gaugeView.backgroundColor = .clear
        gaugeView.ringBackgroundColor = .clear
        gaugeView.divisionsRadius = 1.25 * ratio
        gaugeView.subDivisionsRadius = (1.25 - 0.5) * ratio
        gaugeView.ringThickness = 16 * ratio
        gaugeView.valueFont = UIFont(name: GaugeView.defaultFontName, size: CGFloat(140 * ratio))!
        gaugeView.unitOfMeasurementFont = UIFont(name: GaugeView.defaultFontName, size: CGFloat(16 * ratio))!
        gaugeView.minMaxValueFont = UIFont(name: GaugeView.defaultMinMaxValueFont, size: CGFloat(12 * ratio))!
        gaugeView.ringBackgroundColor = .black
        gaugeView.valueTextColor = .white
        gaugeView.unitOfMeasurementTextColor = UIColor(white: 0.7, alpha: 1)
        gaugeView.minValue = 0
        gaugeView.maxValue = 240
        gaugeView.limitValue = 60
        gaugeView.setNeedsDisplay()
                
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    // GaugeViewDelegate
    func ringStokeColor(gaugeView: GaugeView, value: Double) -> UIColor {
        return UIColor(red: 106.0/255, green: 223.0/255, blue: 180.0/255, alpha: 1)
    }
    
    
    //MARK: - Location Manager
    
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let statisticsVC = navVC.topViewController as! StatisticsViewController
        
        let location = locations.last
        if location!.horizontalAccuracy > 0 {
            
            speed = location!.speed
            direction = location!.course
            
            if let speed = speed {
                
                let speedToMPH = (speed * 2.23694)
                let speedToKPH = (speed * 3.6)
                
                if switchSpeed == "MPH" {
                    gaugeView.value = speedToMPH
                    hudSpeedLabel.text = String(Int(speedToMPH))
                    
                    if startButton.currentTitle != "TRACK" {
                        arrayMPH.append(speedToMPH)
                        let highSpeed = arrayMPH.max()
                        statisticsVC.maxSpeed = (String(format: "%.0f mph", highSpeed!))
                        
                        if let direction = direction {
                            updateLocationInfo(speed: speed, direction: direction)
                        }
                        
                    }
                } else {
                    gaugeView.value = speedToKPH
                    hudSpeedLabel.text = String(Int(speedToKPH))
                    
                    if startButton.currentTitle != "TRACK" {
                        arrayKPH.append(speedToKPH)
                        let highSpeed = arrayKPH.max()
                        statisticsVC.maxSpeed = (String(format: "%.0f km/h", highSpeed!))
                        
                        if let direction = direction {
                            updateLocationInfo(speed: speed, direction: direction)
                        }
                        
                    }
                    
                }
                
                statisticsVC.updateUI()
                avgSpeed()
                
            }
            
        }
        
        if lastLocation != nil && startButton.currentTitle != "TRACK" {
            traveledDistance += lastLocation.distance(from: locations.last!)
            
            if switchSpeed == "MPH" {
                
                gaugeView.unitOfMeasurement = "mph"
                gaugeView.setNeedsDisplay()
                
                if traveledDistance < 1609 {
                    let tdF = traveledDistance / 3.28084
                    distanceTraveled.text = (String(format: "%.1f Feet", tdF))
                    statisticsVC.distance = (String(format: "%.1f Feet", tdF))
                } else if traveledDistance > 1609 {
                    let tdM = traveledDistance * 0.00062137
                    distanceTraveled.text = (String(format: "%.1f Miles", tdM))
                    statisticsVC.distance = (String(format: "%.1f Miles", tdM))
                }
            }
            if switchSpeed == "KPH" {
                
                gaugeView.unitOfMeasurement = "km/h"
                gaugeView.setNeedsDisplay()
                
                if traveledDistance < 1000 {
                    let tdMeter = traveledDistance
                    distanceTraveled.text = (String(format: "%.0f Meters", tdMeter))
                    statisticsVC.distance = (String(format: "%.0f Meters", tdMeter))
                } else if traveledDistance > 1000 {
                    let tdKm = traveledDistance / 1000
                    distanceTraveled.text = (String(format: "%.1f Km", tdKm))
                    statisticsVC.distance = (String(format: "%.1f Km", tdKm))
                }
            }
        }
        lastLocation = locations.last

    }
    
    //MARK: - Update Location Info

    func updateLocationInfo(speed: CLLocationSpeed, direction: CLLocationDirection) {
        let speedToMPH = (speed * 2.23694)
        let speedToKPH = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5);
        let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]

        if switchSpeed == "MPH" {
            let speedLimits: [Double] = [37, 62, 93, 19, 31, 43]
            updateTimeArray(speed: speedToMPH, speedLimits: speedLimits)
        } else {
            let speedLimits: [Double] = [60, 100, 150, 30, 50, 70]
            updateTimeArray(speed: speedToKPH, speedLimits: speedLimits)
        }

        headingDisplay.text = "\(dir)"
             
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let statisticsVC = navVC.topViewController as! StatisticsViewController
        statisticsVC.timeArray = timeArray
        statisticsVC.updateUI()

    }
    
    //MARK: - Update Time Array
    
    func updateTimeArray(speed: Double, speedLimits: [Double]) {
        if speed > 0 {
            print(speed)
            if speed >= speedLimits[0] && timeArray[0] == "0 sec." {
                print(counter)
                timeArray[0] = String(format: "%.1f sec.", counter)
            }
            if speed >= speedLimits[1] && timeArray[1] == "0 sec." {
                timeArray[1] = String(format: "%.1f sec.", counter)
                timeArray[5] = String(format: "%.1f sec.", counter)
            }
            if speed >= speedLimits[2] && timeArray[2] == "0 sec." {
                timeArray[2] = String(format: "%.1f sec.", counter)
            }
            if speed >= speedLimits[3] && timeArray[3] == "0 sec." {
                if extraCounter == nil {
                    extraCounter = counter
                }
            }
            if speed >= speedLimits[4] && timeArray[3] == "0 sec." {
                if let extraCounter = extraCounter {
                    timeArray[3] = String(format: "%.1f sec.", counter - extraCounter)
                }
                extraCounter = counter
            }
            if speed == speedLimits[5] && timeArray[4] == "0 sec." {
                if let extraCounter = extraCounter {
                    timeArray[4] = String(format: "%.1f sec.", counter - extraCounter)
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
            counter = 0.0
            gaugeView.value = 0
        }
    }
    
    //MARK: - Average Speed

    func avgSpeed(){
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let statisticsVC = navVC.topViewController as! StatisticsViewController
            
        if switchSpeed == "MPH" {
            let speed: [Double] = arrayMPH
            let speedAvg = speed.reduce(0, +) / Double(speed.count)
            statisticsVC.avgSpeed = (String(format: "%.0f mph", speedAvg))
        } else if switchSpeed == "KPH" {
            let speed:[Double] = arrayKPH
            let speedAvg = speed.reduce(0, +) / Double(speed.count)
            statisticsVC.avgSpeed = (String(format: "%.0f km/h", speedAvg))
        }
        
        statisticsVC.updateUI()
    }
    
    //MARK: - Update Timers
    
    var miliseconds = 0.0
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    var secondsString = ""
    var minutesString = ""
    var hoursString = ""
    
    @objc func updateTimer() {
        counter += 0.1
        miliseconds += 0.1
        if miliseconds >= 1.0 && miliseconds <= 1.1 {
            seconds += 1
            miliseconds = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        if String(seconds).count == 1 {
            secondsString = "0\(String(seconds))"
        } else {
            secondsString = String(seconds)
        }
        
        if String(minutes).count == 1 {
            minutesString = "0\(String(minutes))"
        } else {
            minutesString = String(minutes)
        }
        
        if String(hours).count == 1 {
            hoursString = "0\(String(hours))"
        } else {
            hoursString = String(hours)
        }
        
        durationLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
        
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let statisticsVC = navVC.topViewController as! StatisticsViewController
        statisticsVC.duration = "\(hoursString):\(minutesString):\(secondsString)"
        statisticsVC.updateUI()
    }

    //MARK: - Buttons
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "HUD" {
            gaugeView.isHidden = true
            containerView.isHidden = true
            hudSpeedLabel.isHidden = false
            hudMeasureLabel.isHidden = false
        } else {
            hudSpeedLabel.isHidden = true
            hudMeasureLabel.isHidden = true
            gaugeView.isHidden = false
            containerView.isHidden = false
        }
        
    }

    @IBOutlet weak var startButton: UIButton!
    @IBAction func startTrip(sender: UIButton) {
        if sender.currentTitle == "TRACK" {
            
            if let speed = speed, let direction = direction {
                updateLocationInfo(speed: speed, direction: direction)
            }
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            
            sender.setTitle("STOP", for: .normal)
        } else {
            sender.setTitle("TRACK", for: .normal)
            timer?.invalidate()
            timer = nil
            counter = 0.0
        }
    }
    
    @IBAction func restTripButton(sender: AnyObject) {
        
        if durationLabel.text != "00:00:00" {
            let navVC = tabBarController?.viewControllers![1] as! UINavigationController
            let statisticsVC = navVC.topViewController as! StatisticsViewController
            statisticsVC.saveObject()
            
            miliseconds = 0.0
            seconds = 0
            minutes = 0
            hours = 0
            secondsString = ""
            minutesString = ""
            hoursString = ""
            
            arrayMPH = []
            arrayKPH = []
            traveledDistance = 0
            headingDisplay.text = ""
            distanceTraveled.text = "0"
            durationLabel.text = "00:00:00"
            startButton.setTitle("TRACK", for: .normal)
            timer?.invalidate()
            timer = nil
            counter = 0.0
            timeArray = ["0 sec.", "0 sec.", "0 sec.", "0 sec.", "0 sec.", "0 sec."]
           
            statisticsVC.timeArray = timeArray
            statisticsVC.maxSpeed = "0"
            statisticsVC.avgSpeed = "0"
            statisticsVC.distance = "0"
            statisticsVC.duration = "00:00:00"
            statisticsVC.updateUI()
        }
    
    }
    
}

