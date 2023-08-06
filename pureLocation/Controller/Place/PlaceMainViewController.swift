//
//  PlaceMainViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit
import GoogleMaps
import CoreLocation

class PlaceMainViewController: UIViewController, CLLocationManagerDelegate {
    weak var delegate : homeDelegate?
    
    var locationManager: CLLocationManager!
    var currentlog : Double = 0.0
    var currentlat : Double = 0.0
    var check : Bool = true
    var zoom : Float = 12.0
    var token : String = ""
    var id : Int = 0

    @IBOutlet weak var FindingButton: UIButton!
    @IBOutlet weak var PlusButton: UIButton!
    @IBOutlet weak var MinusButton: UIButton!
    @IBOutlet weak var MypingButton: UIButton!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var BottomNavigation: UIView!
    @IBOutlet weak var MapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let mapView = GMSMapView(frame: self.MapView.bounds)
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlog, zoom: self.zoom)
        MapView.addSubview(mapView)
        
        FindingButton.layer.cornerRadius = 24
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentlat = location.coordinate.latitude
            self.currentlog = location.coordinate.longitude
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    @IBAction func MyPingAction(_ sender: UIButton) {
        print("ping")
        if check {
            sender.setImage(UIImage(named: "Myping2"), for: .normal)
            check = false
            let mapView = GMSMapView(frame: self.MapView.bounds)
            
            mapView.camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlog, zoom: self.zoom)
            MapView.addSubview(mapView)
        }
        else {
            sender.setImage(UIImage(named: "Myping"), for: .normal)
        }
    }
    
    @IBAction func PlustAction(_ sender: UIButton) {
        self.zoom += 1
        
        let mapView = GMSMapView(frame: self.MapView.bounds)
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlog, zoom: self.zoom)
        MapView.addSubview(mapView)
    }
    
    
    @IBAction func MinusAction(_ sender: UIButton) {
        self.zoom -= 1
        
        let mapView = GMSMapView(frame: self.MapView.bounds)
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: currentlat, longitude: currentlog, zoom: self.zoom)
        MapView.addSubview(mapView)
    }
    
}
