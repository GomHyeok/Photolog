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
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var travelId = 0
    var log : Double = 0
    var lat : Double = 0
    var dateTime : String = ""
    var level1 : String = ""
    var formatted : String = ""
    var assets : [PHAsset] = []
    var imgs : [UIImage] = []
    var data : CalculateResponse?
    var homeData : TravelAPIResponse?
    var currentAssetIndex : Int = 0
    var assetsCount : Int = 0
    
    
    @IBOutlet weak var Home2: UIImageView!
    @IBOutlet weak var Home1: UIImageView!
    @IBOutlet weak var bottomNavigation: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var HomeTable: UITableView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!

    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            let border = CALayer()
            let width = CGFloat(0.5)
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 20, y: self.allView.frame.size.height - width, width:  self.allView.frame.size.width-30, height: width)
            border.borderWidth = width
            self.allView.layer.addSublayer(border)
            self.allView.layer.masksToBounds = true
            
            let upper = CALayer()// 선의 두께
            upper.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
            upper.frame = CGRect(x: 0, y: 0, width:  self.bottomNavigation.frame.size.width, height: width) // 상단에 선을 추가하기 위해 y: 0으로 설정
            upper.borderWidth = width
            self.bottomNavigation.layer.addSublayer(upper)
            self.bottomNavigation.layer.masksToBounds = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviews()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let lineColor = UIColor(red:255/255, green:112/255, blue:66/255, alpha:1.0)
        
        myLabel.setBottomLine(borderColor: lineColor, hight: 3.0, bottom: 12)
        Home1.layer.cornerRadius = 2
        Home2.layer.cornerRadius = 2
        
        TravelApi() {
            self.HomeTable.reloadData()
        }
        
        myLabel.font = UIFont(name : "Pretendard-SemiBold", size: 20)
        allLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        
        HomeTable.dataSource = self
        HomeTable.delegate = self
        
    }
    
    @IBAction func BoardButton(_ sender: UIButton) {
        delegate?.switchToBoard()
    }
    
    @IBAction func ChangeView(_ sender: UIButton) {
        delegate?.switchTotaltToMap(data: self.homeData)
    }
    
    
    @IBAction func MyPageButton(_ sender: UIButton) {
        delegate?.switchToMypage()
    }
    
    @IBAction func Tag(_ sender: UIButton) {
        delegate?.switchToTag()
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
                dispatchGroup.enter()
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.deliveryMode = .highQualityFormat
                
                option.resizeMode = .exact
                
                manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: option, resultHandler: { (image, _) in
                    if let image = image {
                        self?.assets.append(asset)
                        self?.imgs.append(image)
                    }
                    dispatchGroup.leave()
               })
            }
            
            dispatchGroup.notify(queue : .main) {
                self?.assetsCount = self!.assets.count
                self?.processNextAsset()
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
    
    func processNextAsset() {
        if currentAssetIndex < assetsCount {
            let asset = assets[currentAssetIndex]
            let img = imgs[currentAssetIndex]
            currentAssetIndex += 1

            // Process asset (i.e. call photoSave or other async function)
            self.test(img : img, asset: asset) {
                // Once processing is done, process next asset
                self.processNextAsset()
            }
            
        } else {
            calculate {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                if let summaryView = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
                    summaryView.token = self.token
                    summaryView.id = self.id
                    summaryView.travelId = self.travelId
                    summaryView.datas = self.data
                    
                    self.navigationController?.pushViewController(summaryView, animated: true)
                }
                else {print("summary 문제")}
            }
        }
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
                    let index = self.formatted.index(self.formatted.startIndex, offsetBy: 5)
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
        cell.buttonImage.layer.cornerRadius = 8
        
        cell.HomeImageButton.addTarget(self, action: #selector(cellaction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func cellaction(_ sender : UIButton) {
        print(self.homeData?.data[sender.tag].travelId ?? 0)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let daylog = storyboard.instantiateViewController(withIdentifier: "ParentViewController") as? ParentViewController {
            daylog.token = self.token
            daylog.id = self.id
            daylog.travelId = self.homeData?.data[sender.tag].travelId ?? 0
            daylog.datas = self.data
            daylog.check = true
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
    func setBottomLine(borderColor: UIColor, hight : Double, bottom : CGFloat) {
          self.backgroundColor = UIColor.clear
          let borderLine = UIView()
          borderLine.frame = CGRect(x: 0, y: Double(self.frame.height + bottom), width: Double(self.frame.width), height: hight)
          borderLine.backgroundColor = borderColor
          self.addSubview(borderLine)
     }
}
