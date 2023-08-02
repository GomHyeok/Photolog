//
//  SummaryViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit
import CoreImage

class SummaryViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var urls : [URL] = []
    var address : [String] = []
    
    @IBOutlet weak var TavleCalcu: UILabel!
    @IBOutlet weak var ImageCollection: UICollectionView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var PhotoLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        self.ImageCollection.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        self.TavleCalcu.font = UIFont(name: "Pretendard-Bold", size: 24)
        self.PhotoLabel.font = UIFont(name: "Pretendard-Bold", size: 24)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        ImageCollection.collectionViewLayout = layout
        
        self.ImageCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.ImageCollection.dataSource = self
        self.ImageCollection.delegate = self
        self.TavleCalcu.setBottomLine(borderColor: UIColor.black)
        
        self.NextButton.layer.cornerRadius = 10
        self.NextButton.layer.borderWidth=1
        self.NextButton.layer.borderColor = self.NextButton.backgroundColor?.cgColor
    }
    
    
    @IBAction func NexButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let
            travelName = storyboard.instantiateViewController(withIdentifier: "TravelNameViewController") as? TravelNameViewController {
            travelName.token = self.token
            travelName.id = self.id
            travelName.travelId = self.travelId
            travelName.datas = self.datas
            
            self.navigationController?.pushViewController(travelName, animated: true)
        }
        else {print("summary 문제")}
    }
    
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
}

extension SummaryViewController {
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        UserService.shared.locationInfo(locationId: locationId, token: token) {
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? LocationInfoResponse else {return}
                    print(data)
                    let urlList = data.data?.urlList ?? []
                    self.address.append(data.data!.fullAddress)
                    self.urls.append(URL(string: urlList[0])!)
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
}

extension SummaryViewController : UICollectionViewDelegate {
    
}

extension SummaryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas?.data?.locationImg.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: SummaryViewCollectionViewCell.self)
        let font = UIFont(name: "Pretendard-Regular", size: 20)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SummaryViewCollectionViewCell
        
        cell.collectionImage.kf.setImage(with: URL(string : self.datas?.data?.locationImg[indexPath.item] ?? "")!)
        
        //이미지에 대한 설정
        cell.collectionImage.layer.cornerRadius = cell.collectionImage.frame.size.width / 9
        cell.collectionImage.clipsToBounds = true
        
        cell.locationNaem.text = self.datas?.data?.locationAddress[indexPath.item]
        cell.locationNaem.font = UIFont(name: "Pretendard-Regular", size: 14)
        
        
        cell.nights.text = String(datas?.data?.night ?? 0) + "박" + String(datas?.data?.day ?? 0) + "일"
        cell.nights.font = font
        
        cell.During.text = datas?.data?.startDate ?? ""
        cell.During.text! += " ~ "
        cell.During.text! += datas?.data?.endDate ?? ""
        cell.During.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        cell.locationNum.text = "총" + String(datas?.data?.locationNum ?? 0)+"군데를 방문하셨군요"
        cell.locationNum.font = font
        
        cell.customBackgroundView.layer.cornerRadius = cell.customBackgroundView.frame.size.width / 9
        
        return cell
    }
}

extension SummaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
