//
//  MapViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/21.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var TravelTitle: UILabel!
    @IBOutlet weak var TravelMapTable: UITableView!
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var locationData : TravelInfoResponse?
    var settingData : MapInfoResponse?
    var locationArray : [[LocationsData]] = []
    var sequences : [Int] = []
    var locationContent : [String] = []
    var descriptions : [[String]] = []
    var urlArray : [[[URL]]] = []
    var fullAddress : [String] = []
    let pingColor : [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPurple, UIColor.systemMint, UIColor.systemPink, UIColor.black]
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let saveButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(saveButtonAction))
        saveButton.tintColor = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1)
        navigationItem.rightBarButtonItem = saveButton
        
        
        TravelTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
        
        TravelMapTable.delegate = self
        TravelMapTable.dataSource = self
        
        fullAddress = datas?.data?.locationAddress ?? []
        
        let group = DispatchGroup()
        
        group.enter()
        MapInfo {
            self.TravelTitle.text = self.settingData?.data?.title ?? "제목을 찾을 수 없습니다."
            let days = self.settingData?.data?.days ?? []
            for day in days {
                self.locationArray.append(day.locations)
                self.sequences.append(day.sequence)
            }
            group.leave()
        }
        
        group.enter()
        travelInfo {
            if let days = self.locationData?.data?.days {
                for day in days {
                    var descripts : [String] = []
                    var urls : [[URL]] = []
                    for location in day.locations {
                        var arr : [URL] = []
                        self.locationContent.append(location.description ?? "")
                        descripts.append(location.description ?? "설명을 입력해주세요!")
                        for url in location.photoUrls {
                            arr.append(URL(string: url)!)
                        }
                        urls.append(arr)
                    }
                    self.descriptions.append(descripts)
                    self.urlArray.append(urls)
                }
            }
            group.leave()
        }
        
        group.notify(queue : .main) {
            print(self.locationArray)
            print(self.sequences)
            print(self.descriptions)
            print(self.urlArray)
            self.TravelMapTable.reloadData()
        }
    }

    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {let lastSectionIndex = TravelMapTable.numberOfSections - 1 // 마지막 섹션의 인덱스
        let lastRowIndex = TravelMapTable.numberOfRows(inSection: lastSectionIndex) - 1
        var budget : Int = 0
        let indexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        if let cell = TravelMapTable.cellForRow(at: indexPath) as? BudgetCell {
            budget = cell.getBudget()
        } else {
            self.alert(message: "예산을 선택해주세요")
        }
        
        makeArticle(budget: budget) {
            self.navigationController?.popViewController(animated: true)
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let homeView = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController {
                homeView.token = self.token
                homeView.id = self.id
                
                self.navigationController?.pushViewController(homeView, animated: true)
            }
            else {print("홈뷰 문제")}
        }
    }
}


extension MapViewController {
    func MapInfo(completion : @escaping () -> Void) {
        UserService.shared.mapInfo(travelId: travelId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? MapInfoResponse else {return}
                        self.settingData = data
                        print(data)
                        completion()
                    case .requsetErr(let err) :
                        print(err)
                    case .pathErr:
                        print("pathErr")
                        completion()
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                }
            }
    }
    
    func travelInfo(completion : @escaping () -> Void) {
        UserService.shared.travelInfo(travelId: travelId, token: token) {
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? TravelInfoResponse else {return}
                    self.locationData = data
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
    
    func makeArticle (budget : Int, completion : @escaping () -> Void) {
        UserService.shared.makeArticle(token: token, travelId: travelId, title: self.TravelTitle.text!, summary: "미정", locationContent: self.locationContent, budget: budget){
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? MakeArticleResponse else {return}
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                    completion()
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
        let cancleAction = UIAlertAction(title: "취소", style: .default)

        alertVC.addAction(okAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true)
    }
}

extension MapViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section < locationArray.count){
            let st = String(self.sequences[section]) + "일차"
            return st
        }
        else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == locationArray.count {
            return 1
        }
        else {
            return locationArray[section].count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == locationArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetCell
            
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
                
                let mapview = GMSMapView(frame: cell.ContainerView.bounds)
                var cnt : Int = 0
                
                mapview.camera = GMSCameraPosition.camera(withLatitude: self.locationArray[indexPath.section][0].coordinate?.latitude ?? 32.3, longitude: self.locationArray[indexPath.section][0].coordinate?.longitude ?? 32.3, zoom: 9.0)
                
                for cord in locationArray[indexPath.section] {
                    let lat = cord.coordinate?.latitude
                    let log = cord.coordinate?.longitude
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: lat ?? 32.3, longitude: log ?? 32.3)
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
                
                cell.LocationTitle.text = locationArray[indexPath.section][indexPath.row-1].name
                cell.LocationTitle.font = UIFont(name: "Pretandard-Bold", size: 16)
                cell.Descriptions.font = UIFont(name: "Pretandard-Regular", size: 14)
                
                if indexPath.section < urlArray.count {
                    if indexPath.row-1 < urlArray[indexPath.section].count {
                        cell.data = urlArray[indexPath.section][indexPath.row-1]
                    }
                }
                
                if descriptions.count > indexPath.section {
                    if descriptions[indexPath.section].count > indexPath.row - 1 {
                        cell.Descriptions.text = descriptions[indexPath.section][indexPath.row-1]
                    }
                    else {
                        cell.Descriptions.text = "Loading..."
                    }
                }
                else {
                    cell.Descriptions.text = "Loading..."
                }
                cell.FullAddress.text = "api 수정이 필요합니다"
                cell.setData(urlArray[indexPath.section][indexPath.row-1])
                
                return cell
            }
        }
    }
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }
        else {
            return 300.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.textColor = UIColor.init(red: 0.33, green: 0.33, blue: 0.34, alpha: 1.0) // 텍스트 색상 설정
        label.font = UIFont.boldSystemFont(ofSize: 25) // 폰트 크기 및 스타일 설정
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}
