//
//  ViewController.swift
//  Project_22_IBeacon_technology
//
//  Created by Rafael VSM on 11/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//
/*
 for controller in self.navigationController!.viewControllers as Array {
     if controller.isKind(of: ViewController.self) {
         self.navigationController!.popToViewController(controller, animated: true)
         break
     }
 }
 */
import UIKit
import CoreLocation
//This is the Core Location class that lets us configure how we want to be notified about location, and will also deliver location updates to us.

//That doesn't actually create a location manager, or even prompt the user for location permission! To do that, we first need to create the object (easy), then set ourselves as its delegate (easy, but we need to conform to the protocol), then finally we need to request authorization.

class ViewController: UIViewController {
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var deviceInformation: UILabel!
    @IBOutlet var circularView: CircularView!
    
    var locationManager: CLLocationManager?
    
    var didShowAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        // Do any additional setup after loading the view.
    }
    
    //iBeacons are identified using three pieces of information: a universally unique identifier (UUID), plus a major number and a minor number. The first number is a long hexadecimal string that you can create by running the uuidgen in your Mac's terminal. It should identify you or your store chain uniquely.

    //The major number is used to subdivide within the UUID. So, if you have 10,000 stores in your supermarket chain, you would use the same UUID for them all but give each one a different major number. That major number must be between 1 and 65535, which is enough to identify every McDonalds and Starbucks outlet combined!

    //The minor number can (if you wish) be used to subdivide within the major number. For example, if your flagship London store has 12 floors each of which has 10 departments, you would assign each of them a different minor number.
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOW"
                self.circularView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.circularView.cornerRadius = 128 * 0.001
            case .immediate:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "RIGHT HERE"
                self.circularView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.circularView.cornerRadius = 128
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circularView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.circularView.cornerRadius = 128 * 0.5
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circularView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.circularView.cornerRadius = 128 * 0.25
            default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "WHOA!"
                self.circularView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.circularView.cornerRadius = self.circularView.cornerRadius * 0.001
            }
        }) { finished in
            //
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    NSLog("%@", "Range available!")
                    startScanning()
                } else {
                    NSLog("%@", "Range is not available")
                }
            } else {
                NSLog("%@", "Device is not able to monitor IBeacons :(")
            }
        } else {
            NSLog("%@", "Permission denied")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !didShowAlert {
                didShowAlert = true
                let ac = UIAlertController(title: "Found new IBeacon!", message: "Found a bacon with description \(beacon.description)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            }
            if #available(iOS 13.0, *) {
                deviceInformation.text = beacon.uuid.uuidString
            } else {
                deviceInformation.text = beacon.proximityUUID.uuidString
            }
            update(distance: beacon.proximity)
        } else {
            print("unknow")
            update(distance: .unknown)
        }
    }
    
    
}

