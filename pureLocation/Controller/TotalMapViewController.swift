//
//  TotalMapViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/26.
//

import UIKit
import GoogleMaps

class TotalMapViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var cnt : Int = 0
    var settingData : MapInfoResponse?
    var locationArray : [[LocationsData]] = []
    var sequences : [Int] = []
    let pingColor : [UIColor] = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPurple, UIColor.systemMint, UIColor.systemPink, UIColor.black]

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ConTainView: UIView!
    @IBOutlet weak var MapTableView: UITableView!
    
    override func viewDidLayoutSubviews() {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapInfo {
            DispatchQueue.main.async {
                let days = self.settingData?.data?.days ?? []
                for day in days {
                    self.locationArray.append(day.locations)
                    self.sequences.append(day.sequence)
                }
                
                self.TitleLabel.text = self.settingData?.data?.title ?? "제목을 찾을 수 없습니다."
                
                let mapView = GMSMapView(frame: self.ConTainView.bounds)
                mapView.camera = GMSCameraPosition.camera(withLatitude: self.locationArray[0][0].coordinate?.latitude ?? 32.3, longitude: self.locationArray[0][0].coordinate?.longitude ?? 32.3, zoom: 9.0)
                self.ConTainView.addSubview(mapView)
                
                for location in self.locationArray {
                        for cord in location {
                            let lat = cord.coordinate?.latitude
                            let log = cord.coordinate?.longitude
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: lat ?? 32.3, longitude: log ?? 32.3)
                            marker.title = cord.name
                            marker.icon = GMSMarker.markerImage(with: self.pingColor[self.cnt])
                            marker.map = mapView
                    }
                    self.cnt+=1
                    if self.cnt == self.pingColor.count {
                        self.cnt = 0
                    }
                }
            }
        }
    }
}

extension TotalMapViewController {
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
