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
    var settingData : MapInfoResponse?
    var locationArray : [[LocationsData]] = []
    var sequences : [Int] = []
    let pingColor : [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPurple, UIColor.systemMint, UIColor.systemPink, UIColor.black]
    
    override func viewDidLayoutSubviews() {
        MapInfo {
            DispatchQueue.main.async {
                self.TravelTitle.text = self.settingData?.data?.title ?? "제목을 찾을 수 없습니다."
                let days = self.settingData?.data?.days ?? []
                for day in days {
                    self.locationArray.append(day.locations)
                    self.sequences.append(day.sequence)
                }
            }
            
            DispatchQueue.main.async {
                self.TravelMapTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TravelMapTable.delegate = self
        TravelMapTable.dataSource = self
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
}

extension MapViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let st = String(self.sequences[section]) + "일차"
        return st
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            return cell
        }
    }
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }
        else {
            return 50
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
