//
//  AppDelegate.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 01.09.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // - UI
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            let navigationBar = UINavigationBar()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            navigationBar.standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        self.window?.rootViewController = casualRootVC()
        return true
    }
    
    func casualRootVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        return vc
    }


}

