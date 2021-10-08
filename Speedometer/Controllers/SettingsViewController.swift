//
//  SettingsViewController.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 01.09.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var measureButtonContainer: UIView!
    @IBOutlet weak var switchSpeedStatus: UIButton!
    
    let manageUI = ManageUI()
    var speedMeasure = "KPH"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton(rateButton)
        updateButton(supportButton)
        updateButton(privacyPolicyButton)
        manageUI.manageContainerView(measureButtonContainer)
        measureButtonContainer.layer.cornerRadius = 8
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        rateApp()
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func speedSwtich(sender: UIButton) {
        
        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
        let speedometerVC = navVC.topViewController as! SpeedometerViewController
        
        if speedMeasure == "MPH" {
            speedMeasure = "KPH"
            switchSpeedStatus.setTitle("KPH", for: .normal)
            speedometerVC.gaugeView.unitOfMeasurement = "km/h"
            speedometerVC.switchSpeed = "KPH"
            speedometerVC.hudMeasureLabel.text = "KPH"
        } else if speedMeasure == "KPH" {
            speedMeasure = "MPH"
            switchSpeedStatus.setTitle("MPH", for: .normal)
            speedometerVC.switchSpeed = "MPH"
            speedometerVC.gaugeView.unitOfMeasurement = "mph"
            speedometerVC.hudMeasureLabel.text = "MPH"
        }
        
    }
    
    func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func updateButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
    }

}
