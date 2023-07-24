//
//  SummaryViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var urls : [URL] = []
    var address : [String] = []
    
    @IBOutlet weak var TavleCalcu: UILabel!
    @IBOutlet weak var ImageCollection: UICollectionView!
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        ImageCollection.collectionViewLayout = layout
        
        self.ImageCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.ImageCollection.dataSource = self
        self.ImageCollection.delegate = self
        self.TavleCalcu.setBottomLine(borderColor: UIColor.black)
        let locationList = self.datas?.data?.locationList ?? []
        let dispatchGropup = DispatchGroup()
        for location in locationList {
            dispatchGropup.enter()
            locationInfo(locationId: location) {
                dispatchGropup.leave()
            }
        }
        dispatchGropup.notify(queue: .main) {
            self.ImageCollection.reloadData()
        }
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
        print(urls.count)
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: SummaryViewCollectionViewCell.self)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SummaryViewCollectionViewCell
        
        //이미지에 대한 설정
        cell.collectionImage.kf.setImage(with: self.urls[indexPath.item])
        cell.collectionImage.layer.cornerRadius = cell.collectionImage.frame.size.width / 9
        cell.collectionImage.clipsToBounds = true
        
        cell.locationNaem.text = self.address[indexPath.item]
        
        cell.nights.text = String(datas?.data?.night ?? 0) + "박" + String(datas?.data?.day ?? 0) + "일"
        cell.During.text = datas?.data?.startDate ?? ""
        cell.During.text! += " ~ "
        cell.During.text! += datas?.data?.endDate ?? ""
        cell.locationNum.text = "총" + String(datas?.data?.locationNum ?? 0)+"군데를 방문하셨군요"
        
        return cell
    }
}

extension SummaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
