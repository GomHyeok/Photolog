//
//  DayLogViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit

class DayLogViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId: Int = 0
    var datas : CalculateResponse?
    var cnt : Int = 0
    var locationId : [Int] = []
    var settingData : LocationInfoResponse?
    var urlArray : [URL] = []

    
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var PlaceName: UITextField!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    @IBOutlet weak var day: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        PlaceName.isUserInteractionEnabled = false
        Description.isUserInteractionEnabled = false
        locationId = datas?.data?.locationList ?? []
        print(locationId.count)
        locationInfo(locationId: locationId[cnt]) {
            DispatchQueue.main.async{
                self.day.text = String(self.settingData?.data?.sequence ?? 0) + "일차"
                self.years.text = self.settingData?.data?.date ?? "날자를 알수 없습니다."
                self.place.text = self.settingData?.data?.fullAddress ?? "장소를 알 수 없습니다."
                
                if self.settingData?.data?.title == nil {
                    self.PlaceName.text = "이름을 입력해주세요"
                }
                else {
                    self.PlaceName.text = self.settingData?.data?.title
                }
                
                if self.settingData?.data?.description == nil {
                    self.Description.text = "설명을 추가해주세요"
                }
                else {
                    self.Description.text = self.settingData?.data?.description
                }
            }
            
            if let urlList = self.settingData?.data?.urlList {
                let urls = urlList.compactMap { URL(string: $0) }
                self.urlArray = urls
            }
            
            DispatchQueue.main.async {
                self.ImageCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ImageCollectionView.dataSource = self
        ImageCollectionView.delegate = self
        
        if let layout = ImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: ImageCollectionView.bounds.width / 2, height: ImageCollectionView.bounds.height)
        }

    }
    
    @IBAction func MakePlaceName(_ sender: UIButton) {
        if PlaceName.isUserInteractionEnabled {
            PlaceName.isUserInteractionEnabled = false
            locationName(locationId: self.locationId[self.cnt], title: PlaceName.text!)
            {
                print("change location name")
            }
        }
        else {
            PlaceName.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func MakeDiscription(_ sender: UIButton) {
        if Description.isUserInteractionEnabled {
            Description.isUserInteractionEnabled = false
            locationDescription(locationId: locationId[cnt], description: Description.text!)
            {
                print("change location Description")
            }
        }
        else {
            Description.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func NextDayButton(_ sender: UIButton) {
        cnt += 1
        if cnt < locationId.count {
            locationInfo(locationId: locationId[cnt]) {
                DispatchQueue.main.async{
                    self.day.text = String(self.settingData?.data?.sequence ?? 0) + "일차"
                    self.years.text = self.settingData?.data?.date ?? "날자를 알수 없습니다."
                    self.place.text = self.settingData?.data?.fullAddress ?? "장소를 알 수 없습니다."
                    
                    if self.settingData?.data?.title == nil {
                        self.PlaceName.text = "이름을 입력해주세요"
                    }
                    else {
                        self.PlaceName.text = self.settingData?.data?.title
                    }
                    
                    if self.settingData?.data?.description == nil {
                        self.Description.text = "설명을 추가해주세요"
                    }
                    else {
                        self.Description.text = self.settingData?.data?.description
                    }
                }
                
                if let urlList = self.settingData?.data?.urlList {
                    let urls = urlList.compactMap { URL(string: $0) }
                    self.urlArray = urls
                }
                
                DispatchQueue.main.async {
                    self.ImageCollectionView.reloadData()
                }
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let
                total = storyboard.instantiateViewController(withIdentifier: "TotalViewController") as? TotalViewController {
                total.token = self.token
                total.id = self.id
                total.travelId = self.travelId
                total.datas = self.datas
                
                self.navigationController?.pushViewController(total, animated: true)
            }
            else {print("total 문제")}
        }
    }
    
}

extension DayLogViewController {
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        UserService.shared.locationInfo(locationId: locationId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? LocationInfoResponse else {return}
                        print(data)
                        self.settingData = data
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
    
    func locationName (locationId : Int, title : String, completion : @escaping () -> Void) {
        UserService.shared.locationName(locationId: locationId, token: token, title: title) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? staticResponse else {return}
                        print(data)
                        self.alert(message: "장소 이름이 설정되었습니다.")
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
    
    func locationDescription (locationId : Int, description : String, completion : @escaping () -> Void) {
        UserService.shared.locationDiscription(locationId: locationId, token: token, description: description) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? staticResponse else {return}
                        print(data)
                        self.alert(message: "설명이 설정되었습니다.")
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
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

extension UIImageView {
    func load(url : URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}

//MARK: - CollectionView
extension DayLogViewController : UICollectionViewDelegate{
    
}

extension DayLogViewController : UICollectionViewDataSource {
    
    //각 섹션에 들어가는 item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    //각 collection view cell에 대한 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = String(describing: DayLogCollectionViewCell.self)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DayLogCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        
        print(indexPath.item)
        //이미지에 대한 설정
        cell.location.load(url: self.urlArray[indexPath.item])
        
        return cell
    }
}


//MARK: - 콜렉션 부 컴포지셔널 레이아웃 관련
extension DayLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
    }
}

