//
//  DayLogViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit
import Kingfisher

class DayLogViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId: Int = 0
    var datas : CalculateResponse?
    var cnt : Int = 0
    var locationId : [Int] = []
    var settingData : LocationInfoResponse?
    var urlArray : [URL] = []
    var images : [UIImage] = []

    
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var PlaceName: UITextField!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    @IBOutlet weak var day: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineColor = UIColor(red:192/255, green:192/255, blue:192/255, alpha:1.0)
        self.PlaceName.setBottomLine(borderColor: lineColor)
        
        ImageCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ImageCollectionView.dataSource = self
        ImageCollectionView.delegate = self
        
        if let layout = ImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: ImageCollectionView.bounds.width / 2, height: ImageCollectionView.bounds.height)
        }
        
        self.locationId = datas?.data?.locationIdList ?? []
        locationInfo(locationId: self.locationId[cnt]) {
            DispatchQueue.main.async{
                self.day.text = "DAY"
                self.day.text! += String(self.settingData?.data?.sequence ?? 0)
                self.years.text = self.settingData?.data?.date ?? "날자를 알수 없습니다."
                self.place.text = self.settingData?.data?.fullAddress ?? "장소를 알 수 없습니다."

                if self.settingData?.data?.name == nil {
                    self.PlaceName.text = "이름을 입력해주세요"
                }
                else {
                    self.PlaceName.text = self.settingData?.data?.name
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
    
    @IBAction func NextDayButton(_ sender: UIButton) {
        locationName(locationId: locationId[cnt], title: PlaceName.text!) { [self] in
            locationDescription(locationId: self.locationId[self.cnt], description: self.Description.text!) {
                if self.cnt < self.locationId.count {
                    self.locationInfo(locationId: self.locationId[self.cnt]) {
                        DispatchQueue.main.async{
                            self.day.text = "DAY"
                            self.day.text! += String(self.settingData?.data?.sequence ?? 0)
                            self.years.text = self.settingData?.data?.date ?? "날자를 알수 없습니다."
                            self.place.text = self.settingData?.data?.fullAddress ?? "장소를 알 수 없습니다."
                            
                            if self.settingData?.data?.name == nil {
                                self.PlaceName.text = "이름을 입력해주세요"
                            }
                            else {
                                self.PlaceName.text = self.settingData?.data?.name
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
        cnt+=1
        if cnt >= locationId.count {
            cnt = 0
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
        cell.location.kf.setImage(with: urlArray[indexPath.item])
        
        return cell
    }
}


//MARK: - 콜렉션 부 컴포지셔널 레이아웃 관련
extension DayLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
    }
}

