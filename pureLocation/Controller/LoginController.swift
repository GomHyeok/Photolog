//
//  LoginController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//


import UIKit
import Photos
import BSImagePicker
import CoreLocation
import MapKit

class LoginController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    var travelId : Int = 0
    var token : String = ""
    var id : Int = 0
    var log : Double = 0
    var lat : Double = 0
    var dateTime : String = ""
    var level1 : String = ""
    var formatted : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func LoginButton(_ sender: Any) {
        print("Login")
        login()
        print(token)
    }
    
    
    @IBAction func DeleteButton(_ sender: UIButton) {
        print(token)
        print(id)
        print("Delete")
        delete()
    }
    
    
    @IBAction func TravleButton(_ sender: UIButton) {
        print(token)
        travel()
    }
    
    @IBAction func insertButton(_ sender: UIButton) {
        
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
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.deliveryMode = .highQualityFormat
                
                option.resizeMode = .exact

               manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: option, resultHandler: { (image, _) in
                   if let image = image {
                       // Pass the UIImage to the photoSave function
                       //self?.photoSave(img: image)
                       self?.test()
                       print(self?.level1)
                       print(self?.formatted)
                       self?.photoSave(img: image)
                   }
               })
            }
        })
        
    }
    
    
    @IBAction func CalculateButton(_ sender: UIButton) {
        print("Calculate")
        calculate()
    }
    
    func getPhotoLocationInfo(asset: PHAsset) {
        print("print location")
        guard let location = asset.location else {
            print("No location info available for this asset.")
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        self.log = longitude
        self.lat = latitude
        
        print("Location: \(latitude), \(longitude)")
    }

    func getPhotoCreationDate(asset: PHAsset) {
        if let creationDate = asset.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.dateTime = dateFormatter.string(from: creationDate)
            print(creationDate)
            print("The photo was created at: \(creationDate)")
        } else {
            print("Could not retrieve the creation date.")
        }
    }
    
}

extension LoginController {
    func login() {
        guard let email = Email.text else {return}
        guard let password = Password.text else {return}
        
        print(email)
        print(password)
        
        UserService.shared.login(
            email: email,
            password: password) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? LoginResponse else {return}
                        self.token = data.data?.token ?? ""
                        self.id = data.data?.userId ?? 0
                        self.alert(message : data.message)
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    
    func delete() {
        UserService.shared.delete(
            id: id,
            token: token) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? DeleteResponse else {return}
                        print(data)
                        self.alert(message : data.message)
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    
    func travel() {
        UserService.shared.travel(
            token: token) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? TravelResponse else {return}
                        print(data)
                        self.travelId = data.data ?? 0
                        self.alert(message : data.message)
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    
    func photoSave(img : UIImage) {
        UserService.shared.PhotoSave(travelId: 1, token: token, img: img, dateTime: dateTime, log: log, lat: lat, city: level1, fullAddress : formatted){
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? PhotoSaveResponse else {return}
                        print(data)
                        self.alert(message : data.message)
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    
    func calculate() {
        UserService.shared.calculate(token: token, id: 1) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? CalculateResponse else {return}
                        print(data)
                        print(data.status)
                        self.travelId = data.data ?? 0
                        self.alert(message : data.message)
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    func test() {
        UserService.shared.test(token: token, id: 5, log: log, lat: lat) { response in
            switch response {
            case .success(let data):
                guard let data = data as? testmodel else { return }
                for result in data.results {
                    for addressComponent in result.addressComponents {
                        if addressComponent.types.contains("administrative_area_level_1") {
                            self.level1 = addressComponent.longName
                        }
                    }
                }
                self.formatted = data.results.first?.formattedAddress ?? "찾을 수 없음"
            case .requsetErr(let err):
                print(err)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }

    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
