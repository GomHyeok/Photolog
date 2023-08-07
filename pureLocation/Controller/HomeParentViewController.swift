//
//  HomeParentViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit
import Photos
import BSImagePicker
import Kingfisher

class HomeParentViewController: UIViewController, homeDelegate {
    var firstChild : HomeViewController!
    var secondChild : HomeNameViewController!
    var boardChild : BoardMainViewController!
    var keywordChild : AfterKeywordViewController!
    var myPageChild : MyPageMainViewController!
    var tagChild : TagMainViewController!
    var placeChild : PlaceMainViewController!
    var loading : LoadingViewController!
    var parents : HomeParentViewController!
    
    
    var homeData : TravelAPIResponse?
    var currentViewController : UIViewController!
    var now : Bool = false
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
    var currentAssetIndex : Int = 0
    var assetsCount : Int = 0
    var check = true
    var loadingView: UIView!
    var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var Mylabel: UILabel!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var bottomNavigation: UIView!
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            if self.check {
                let border = CALayer()
                let width = CGFloat(0.2)
                border.borderColor = UIColor.darkGray.cgColor
                border.frame = CGRect(x: 0, y: self.allView.frame.size.height - width, width:  self.allView.frame.size.width, height: width)
                border.borderWidth = width
                self.allView.layer.addSublayer(border)
                self.allView.layer.masksToBounds = true
                
                let upper = CALayer()// 선의 두께
                upper.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor // 선의 색상
                upper.frame = CGRect(x: 0, y: 0, width:  self.bottomNavigation.frame.size.width, height: width) // 상단에 선을 추가하기 위해 y: 0으로 설정
                upper.borderWidth = width
                
                self.bottomNavigation.layer.addSublayer(upper)
                self.bottomNavigation.layer.masksToBounds = true
                self.check = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineColor = UIColor(red:255/255, green:112/255, blue:66/255, alpha:1.0)
        Mylabel.setBottomLine(borderColor: lineColor, hight: 3.0, bottom: 10)
        
        Mylabel.font = UIFont(name : "Pretendard-SemiBold", size: 20)
        allLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        
        //네비게이션 뷰 버튼 수정
        self.navigationController?.isNavigationBarHidden = true
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        firstChild = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        parents = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController
        
        secondChild = storyboard.instantiateViewController(withIdentifier: "HomeNameViewController") as? HomeNameViewController
        
        loading = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController
        
        let board = UIStoryboard(name: "Board", bundle: nil)
        boardChild = board.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController
        
        let keyword = UIStoryboard(name: "Board", bundle: nil)
        keywordChild = keyword.instantiateViewController(withIdentifier: "AfterKeywordViewController") as? AfterKeywordViewController
        
        let mypage = UIStoryboard(name: "MyPage", bundle: nil)
        myPageChild = mypage.instantiateViewController(withIdentifier: "MyPageMainViewController") as? MyPageMainViewController
        
        let tagpage = UIStoryboard(name: "TagPage", bundle: nil)
        tagChild = tagpage.instantiateViewController(withIdentifier: "TagMainViewController") as? TagMainViewController
        
        let place = UIStoryboard(name: "Place", bundle: nil)
        placeChild = place.instantiateViewController(withIdentifier: "PlaceMainViewController") as? PlaceMainViewController
        
        // delegate 설정
        placeChild.delegate = self
        firstChild.delegate = self
        secondChild.delegate = self
        boardChild.delegate = self
        myPageChild.delegate = self
        tagChild.delegate = self
        
        TravelApi {
            self.firstChild.token = self.token
            self.firstChild.id = self.id
            self.firstChild.homeData = self.homeData
            
            self.currentViewController = self.firstChild
            
            self.addChild(self.firstChild)
            self.firstChild.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(self.firstChild.view)
            self.firstChild.didMove(toParent: self)
        }
    }
    
    
    @IBOutlet weak var TotalMap: UIImageView!
    @IBOutlet weak var toMap: UIImageView!
    
    @IBAction func ToTotal(_ sender: UIButton) {
        if now {
            now = false
            TotalMap.image = UIImage(named: "home1")
            toMap.image = UIImage(named: "home1-2")
            switchMaptoTotal()
        }
        else {
            
        }
    }
    
    @IBAction func ToMapAction(_ sender: UIButton) {
        if now {
            
        }
        else {
            now = true
            toMap.image = UIImage(named: "home2-2")
            TotalMap.image = UIImage(named: "home2")
            switchTotaltToMap(data: self.homeData)
        }
    }
    
    
    func switchTotaltToMap(data: TravelAPIResponse?) {
        firstChild.willMove(toParent: nil)
        secondChild.token = self.token
        secondChild.id = self.id
        secondChild.homeData = self.homeData
        currentViewController = secondChild

        // 뷰의 초기 위치를 설정합니다.
        secondChild.view.frame.origin.x = self.ContainerView.frame.width
        self.addChild(secondChild)
        self.ContainerView.addSubview(secondChild.view)

        // 슬라이드 애니메이션 적용
        UIView.animate(withDuration: 0.3, animations: {
            self.firstChild.view.frame.origin.x = -self.ContainerView.frame.width
            self.secondChild.view.frame.origin.x = 0
        }) { (finished) in
            self.firstChild.view.removeFromSuperview()
            self.firstChild.removeFromParent()
            self.secondChild.didMove(toParent: self)
        }
    }
    
    
    func switchMaptoTotal() {
        secondChild.willMove(toParent: nil)
        firstChild.token = self.token
        firstChild.id = self.id
        firstChild.homeData = self.homeData
        currentViewController = firstChild

        // 뷰의 초기 위치를 설정합니다.
        firstChild.view.frame.origin.x = -self.ContainerView.frame.width
        self.addChild(firstChild)
        self.ContainerView.addSubview(firstChild.view)

        // 슬라이드 애니메이션 적용
        UIView.animate(withDuration: 0.3, animations: {
            self.secondChild.view.frame.origin.x = self.ContainerView.frame.width
            self.firstChild.view.frame.origin.x = 0
        }) { (finished) in
            self.secondChild.view.removeFromSuperview()
            self.secondChild.removeFromParent()
            self.firstChild.didMove(toParent: self)
        }
    }


    
    func switchToBoard() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        boardChild.token = self.token
        boardChild.id = self.id
        
        currentViewController = boardChild
        
        addChild(boardChild)
        view.addSubview(boardChild.view)
        boardChild.didMove(toParent: self)
    }
    
    func switchToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let summaryView = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController {
            summaryView.token = self.token
            summaryView.id = self.id
            summaryView.travelId = self.travelId
            
            self.navigationController?.pushViewController(summaryView, animated: true)
        }
        else {print("summary 문제")}
    }
    
    func switchToMypage() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        myPageChild.token = self.token
        myPageChild.id = self.id
        
        currentViewController = myPageChild
        
        addChild(myPageChild)
        view.addSubview(myPageChild.view)
        myPageChild.didMove(toParent: self)
    }
    
    func switchToTag() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        tagChild.token = self.token
        tagChild.id = self.id
        
        currentViewController = tagChild
        
        addChild(tagChild)
        view.addSubview(tagChild.view)
        tagChild.didMove(toParent: self)
    }
    
    func switchToMap() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        placeChild.token = self.token
        placeChild.id = self.id
        
        currentViewController = placeChild
        
        addChild(placeChild)
        view.addSubview(placeChild.view)
        placeChild.didMove(toParent: self)
    }
    
    func showLoading() {
        loadingView = UIView()
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = UIColor(white: 0.5, alpha: 0.7) // 반투명 검은색 배경
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        // 스피너의 초기화
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loadingView.center
        spinner.startAnimating()
        loadingView.addSubview(spinner)
    }
    
    func hideLoading() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
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
                DispatchQueue.main.async {
                    self.hideLoading()
                }
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
    
    
    @IBAction func makeTravel(_ sender: UIButton) {
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
                DispatchQueue.main.async {
                    self?.showLoading()
                }
                self?.assetsCount = self!.assets.count
                self?.processNextAsset()
            }
        })
    }
    
    
    @IBAction func collection(_ sender: UIButton) {
        switchToTag()
    }
    
    @IBAction func Mypage(_ sender: UIButton) {
        switchToMypage()
    }
    
    @IBAction func Board(_ sender: UIButton) {
        switchToBoard()
    }
}


extension HomeParentViewController {
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
