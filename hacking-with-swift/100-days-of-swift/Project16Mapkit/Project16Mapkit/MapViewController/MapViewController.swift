//
//  ViewController.swift
//  Project16Mapkit
//
//  Created by rafaeldelegate on 11/24/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import MapKit
let capitalIdentifier = "Capital"
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        /*
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
        */
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        mapSwitch.addTarget(self, action: #selector(handleSwitchTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func handleSwitchTapped(sender: UISwitch) {
        if sender.isOn {
            mapView.mapType = .satellite
        } else {
            mapView.mapType = .standard
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: capitalIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: capitalIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .purple
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Go to Wikipedia", style: .default, handler: { (action) in
            self.handleWikipediaTapped(action: action, path: placeName ?? "")
        }))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func handleWikipediaTapped(action: UIAlertAction, path: String) {
        let controller = WebViewController(nibName: "WebViewController", bundle: .main)
        controller.path = path
        navigationController?.pushViewController(controller, animated: true)
    }
}

