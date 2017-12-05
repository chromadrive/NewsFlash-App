//
//  LocationSelectorViewController.swift
//
//
//  Created by Entei Suzuki-Minami on 12/5/17.
//

import Foundation
import UIKit
import MapKit

class LocationSelectorViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet var countryLabel: UILabel!
    
    var country : String?
    
    @IBOutlet var arrowButton: UIButton!
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrowButton.backgroundColor = nil
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegionMake(mapView.centerCoordinate, MKCoordinateSpanMake(180, 360)), animated: true)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        let lat = coordinate.latitude
        let long = coordinate.longitude
        let loc = CLLocation(latitude: lat, longitude: long)
        
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
                
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    if let addr = placemark.country {
                        self.country = addr
                        self.countryLabel.text = self.country
                        self.arrowButton.setImage(UIImage(named: "arrow_g.png"), for: .normal)
                    } else {
                        
                        self.countryLabel.text = "Tap on a country"
                        self.arrowButton.setImage(UIImage(named: "arrow.png"), for: .normal)
                    }
                    
                } else {
                    print("no matching")
                }
            }
            
        }
        
    }
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        print(country)
        if country != nil {
            performSegue(withIdentifier: "showLocationSearch", sender: submitButton)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? LocationSearchTableViewController {
            dest.location = country
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

