//
//  BoardViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/01.
//

import UIKit
import GoogleMaps

class BoardViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var ArticleId : Int = 0
    var settingData : ArticleInfoResponse?
    let pingColor : [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPurple, UIColor.systemMint, UIColor.systemPink, UIColor.black]
    
    @IBOutlet weak var TravelTable: UITableView!
    
    @IBOutlet weak var BookNum: UILabel!
    @IBOutlet weak var HartNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        
        
        TravelTable.delegate = self
        TravelTable.dataSource = self
        
        
        
        articleInfo {
            self.HartNum.text = String(self.settingData?.data?.likes ?? 0)
            self.BookNum.text = String(self.settingData?.data?.bookmarks ?? 0)
            self.TravelTable.reloadData()
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
}

extension BoardViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.settingData?.data?.days?.count ?? 0) + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == (self.settingData?.data?.days?.count ?? 0) + 1 {
            return 1
        }
        else {
            return (self.settingData?.data?.days?[section-1].locations?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardStart", for: indexPath) as! BoardStart
            cell.Title.text = self.settingData?.data?.title ?? ""
            cell.Title.font = UIFont(name: "Pretendard-Bold", size: 24)
            cell.Location.text = self.settingData?.data?.days?[0].locations?[0].city
            cell.Location.font = UIFont(name: "Pretendard-Regular", size: 14)
            cell.Creator.text = "by."
            cell.Creator.text! += self.settingData?.data?.nickname ?? ""
            cell.Creator.font = UIFont(name: "Pretendard-Regular", size: 14)
            //cell.Descript.text = self.settingData?.data.
            cell.Descript.font = UIFont(name: "Pretendard-Regular", size: 14)
            cell.TableImage.kf.setImage(with: URL(string: self.settingData?.data?.days?[0].locations?[0].photoUrls[0] ?? ""))
            
            
            return cell
        }
        else if indexPath.section == (self.settingData?.data?.days?.count ?? 0) + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardBudget", for: indexPath) as! BoardBudget
            cell.BudgetLabel.text = "총 "
            cell.BudgetLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
            cell.BudgetLabel.text! += String(settingData?.data?.budget ?? 0)
            
            cell.GroupMemeber.text = self.settingData?.data?.member ?? "구성원이 입력되지 않았습니다."
            cell.GroupMemeber.font = UIFont(name: "Pretendard-Bold", size: 16)
            
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
                
                let mapview = GMSMapView(frame: cell.ContainerView.bounds)
                var cnt : Int = 0
                
                mapview.camera = GMSCameraPosition.camera(withLatitude: self.settingData?.data?.days?[indexPath.section-1].locations?[0].coordinate.latitude ?? 32.3, longitude: self.settingData?.data?.days?[indexPath.section-1].locations?[0].coordinate.longitude ?? 32.3, zoom: 9.0)
                
                for cord in self.settingData?.data?.days?[indexPath.section-1].locations ?? [] {
                    let lat = cord.coordinate.latitude
                    let log = cord.coordinate.longitude
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: lat , longitude: log )
                    marker.title = cord.name
                    marker.icon = GMSMarker.markerImage(with: pingColor[cnt])
                    marker.map = mapview
                    
                    cnt+=1
                    if cnt == pingColor.count {
                        cnt = 0
                    }
                }
                
                cell.ContainerView.addSubview(mapview)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationInfoCell", for: indexPath) as! LocationInfoCell
                
                if "" == self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].name {
                    cell.LocationTitle.text = "이름을 입력해주세요"
                }
                else {
                    cell.LocationTitle.text = self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].name
                }
                
                cell.LocationTitle.font = UIFont(name: "Pretandard-Bold", size: 16)
                cell.Descriptions.font = UIFont(name: "Pretandard-Regular", size: 14)
                
                if indexPath.row-1 < self.settingData?.data?.days?[indexPath.section-1].locations?.count ?? 0 {
                    var data : [URL] = []
                    
                    for url in self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].photoUrls ?? [] {
                        data.append(URL(string: url)!)
                    }
                    cell.data = data
                }
                
                if self.settingData?.data?.days?[indexPath.section-1].locations?.count ?? 0 > indexPath.row - 1 {
                    cell.Descriptions.text = self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].content ?? ""
                }
                else {
                    cell.Descriptions.text = "Loading..."
                }
                cell.FullAddress.text = self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].degree ?? ""
                cell.setData(cell.data)
                
                return cell
            }
        }
    }
}

extension BoardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 600
        }
        else if indexPath.section ==  (self.settingData?.data?.days?.count ?? 0) + 1{
            return 100.0
        }
        else if indexPath.row == 0{
            return 200.0
        }
        else {
            return 300.0
        }
    }
    
}


extension BoardViewController {
    func articleInfo (completion: @escaping () -> Void) {
        UserService.shared.ArticleInfo(token: token, articleId: ArticleId) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? ArticleInfoResponse else {return}
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
}
