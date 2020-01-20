//
//  ViewController.swift
//  Consolidation_IX
//
//  Created by Rafael VSM on 19/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
import CoreLocation
/*
 Providing co-ordinates for the user’s location at a granularity you specify.
 Tracking the places the user has visited.
 Indoor location, even down to what floor a user is on, for locations that have been configured by Apple.
 Geocoding, which converts co-ordinates to user-friendly names like cities and streets.
 */

class ViewController: UIViewController , CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.startMonitoringVisits()
      
        5.times({
            print("we are")
        })
        
        var numbers = [1, 2, 3, 4, 5]
        numbers.remove(item: 3)
        print(numbers)
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to find user's location: \(error.localizedDescription)")
    }
    
    //When the user arrives or departs from a location, you’ll get a callback method if you implement it. The method is the same regardless of whether the user arrived or departed at the location, so you need to check the departureDate property to decide.
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        if visit.departureDate == .distantFuture {
            print("User arrived at location \(visit.coordinate) at time \(visit.arrivalDate)")
        } else {
            print("User departed location \(visit.coordinate) at time \(visit.departureDate)")
        }
    }
}

