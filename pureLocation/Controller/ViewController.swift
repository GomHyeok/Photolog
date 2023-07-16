//
//  ViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/11.
//

import UIKit
import Photos
import BSImagePicker
import CoreLocation
import MapKit

class ViewController: UIViewController , MKMapViewDelegate{
    
    let status = PHPhotoLibrary.authorizationStatus()
    let locationManager = CLLocationManager()
    

    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .notDetermined:
                print("Photo Library permission not determined.")
            case .restricted:
                print("Photo Library access is restricted.")
            case .denied:
                print("Photo Library permission was denied by the user.")
            case .authorized:
                print("Photo Library permission was authorized by the user.")
            case .limited:
                print("limited")
            @unknown default:
                print("Unknown Photo Library authorization status.")
            }
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
        }
        
        locationManager.requestLocation()
    }
    
    
    @IBAction func Select(_ sender: UIButton) {
        let imagePicker = ImagePickerController()

        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { [weak self](assets) in
            // User finished selection assets.
            for asset in assets {
                // Get location and time information
                self?.getPhotoLocationInfo(asset: asset)
                self?.getPhotoCreationDate(asset: asset)
            }
        })
    }
    
    
    func getPhotoLocationInfo(asset: PHAsset) {
        print("print location")
        guard let location = asset.location else {
            print("No location info available for this asset.")
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        setAnnotation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.1, title: "사진1", subtitle: "선택된 사진")
        
        print("Location: \(latitude), \(longitude)")
    }

    func getPhotoCreationDate(asset: PHAsset) {
        if let creationDate = asset.creationDate {
            print("The photo was created at: \(creationDate)")
        } else {
            print("Could not retrieve the creation date.")
        }
    }
    
    // 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    func goLocation(latitudeValue: CLLocationDegrees,
                    longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span :Double,
                       title strTitle: String,
                       subtitle strSubTitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }

}


extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

