//
//  HomeViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit
import Photos
import BSImagePicker
import Kingfisher

class HomeViewController: UIViewController {
    weak var delegate : ChildViewControllerDelegate?
    
    var token : String = ""
    var id : Int = 0
    var travelId = 0
    var log : Double = 0
    var lat : Double = 0
    var dateTime : String = ""
    var level1 : String = ""
    var formatted : String = ""
    var data : CalculateResponse?
    var homeData : TravelAPIResponse?
    
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var HomeTable: UITableView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!

    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineColor = UIColor(red:255/255, green:112/255, blue:66/255, alpha:1.0)
        let lineColor2 = UIColor(red:209/255, green:209/255, blue:214/255, alpha:1.0)
        myLabel.setBottomLine(borderColor: lineColor, hight: 1.0)
        
        TravelApi() {
            self.HomeTable.reloadData()
        }
        
        allView.backgroundColor = UIColor.clear
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(allView.frame.height), width: Double(allView.frame.width), height: 0.3)
        borderLine.backgroundColor = lineColor2
        allView.addSubview(borderLine)
        
        myLabel.font = UIFont(name : "Pretendard-Bold", size: 20)
        allLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        
        
        
        
        HomeTable.dataSource = self
        HomeTable.delegate = self
        
    }
    
    
    @IBAction func ChangeView(_ sender: UIButton) {
        delegate?.switchTotaltToMap()
    }
    
    
    @IBAction func TravelCreate(_ sender: UIButton) {
        
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
        
        travel() {
            print("travel")
        }
        
        //pick Image
        let imagePicker = ImagePickerController()

        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { [weak self](assets) in
            let dispatchGroup = DispatchGroup()
            
            // User finished selection assets.
            for asset in assets {
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.deliveryMode = .highQualityFormat
                
                option.resizeMode = .exact
                
                manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: option, resultHandler: { (image, _) in
                    if let image = image {
                        dispatchGroup.enter()
                        self?.test(img : image, asset: asset){
                            dispatchGroup.leave()
                        }
                    }
                    else {
                        dispatchGroup.leave()
                    }
               })
            }
            dispatchGroup.notify(queue: .main) {
                print("ALL photos saved")
                self?.calculate() {
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    if let summaryView = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
                        summaryView.token = self?.token ?? ""
                        summaryView.id = self?.id ?? 0
                        summaryView.travelId = self?.travelId ?? 0
                        summaryView.datas = self?.data
                        
                        self?.navigationController?.pushViewController(summaryView, animated: true)
                    }
                    else {print("summary 문제")}
                }
            }
        })
        
        
    }
    
    func getPhotoLocationInfo(asset: PHAsset) -> (longitude: Double, latitude: Double) {
        guard let location = asset.location else {
            print("No location info available for this asset.")
            return (0,0)
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        self.log = longitude
        self.lat = latitude
        
        return (longitude, latitude)
    }

    func getPhotoCreationDate(asset: PHAsset) -> String {
        var result : String = ""
        if let creationDate = asset.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.dateTime = dateFormatter.string(from: creationDate)
            result = dateFormatter.string(from: creationDate)
        } else {
            print("Could not retrieve the creation date.")
        }
        
        return result
    }
}

extension HomeViewController {
    func travel(completion: @escaping () -> Void) {
        UserService.shared.travel(
            token: token) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? TravelResponse else {return}
                        print(data)
                        self.travelId = data.data ?? 0
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
                completion()
            }
    }
    
    func photoSave(img : UIImage, log : Double, lat: Double, date : String, completion: @escaping () -> Void) {
        UserService.shared.PhotoSave(travelId: travelId, token: token, img: img, dateTime: date, log: log, lat: lat, city: level1, fullAddress : formatted){
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? PhotoSaveResponse else {return}
                        print(data)
                        completion()
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
    
    func calculate(completion : @escaping () -> Void) {
        UserService.shared.calculate(token: token, id: travelId) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? CalculateResponse else {return}
                        self.data = data
                        print(data)
                        print(data.status)
                        completion()
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
    
    func test(img : UIImage, asset: PHAsset, completion: @escaping () -> Void) {
        let info = self.getPhotoLocationInfo(asset: asset)
        let date = self.getPhotoCreationDate(asset: asset)
        let latitude = info.latitude
        let logtitude = info.longitude
        UserService.shared.test(token: token, id: travelId, log: logtitude, lat: latitude) { response in
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
                    let index = self.formatted.index(self.formatted.startIndex, offsetBy:  4)
                    self.formatted = String(self.formatted[index...])
                case .requsetErr(let err):
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
            self.photoSave(img: img, log: logtitude, lat : latitude, date: date, completion: completion)
        }
    }
    
    func TravelApi(completion : @escaping () -> Void) {
        UserService.shared.TravelAPI(token: token) { response in
            switch response {
                case .success(let data):
                    guard let data = data as? TravelAPIResponse else { return }
                    self.homeData = data
                    completion()
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

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.HomeImageButton.tag = indexPath.row
        cell.buttonImage.kf.setImage(with: URL(string : homeData?.data[indexPath.item].thumbnail ?? "")!)
        cell.buttonImage.layer.cornerRadius = cell.buttonImage.frame.width/15
        
        cell.HomeImageButton.addTarget(self, action: #selector(cellaction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func cellaction(_ sender : UIButton) {
        print(self.homeData?.data[sender.tag].travelId ?? 0)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let daylog = storyboard.instantiateViewController(withIdentifier: "TotalViewController") as? TotalViewController {
            daylog.token = self.token
            daylog.id = self.id
            daylog.travelId = self.homeData?.data[sender.tag].travelId ?? 0
            daylog.datas = self.data
            
            self.navigationController?.pushViewController(daylog, animated: true)
        }
        else {print("summary 문제")}
    }
    
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200.0 // 예시로 높이를 100으로 고정하였습니다.
    }
}

extension UILabel {
    func setBottomLine(borderColor: UIColor, hight : Double) {
          self.backgroundColor = UIColor.clear
          let borderLine = UIView()
          borderLine.frame = CGRect(x: 0, y: Double(self.frame.height), width: Double(self.frame.width), height: hight)
          borderLine.backgroundColor = borderColor
          self.addSubview(borderLine)
     }
}
