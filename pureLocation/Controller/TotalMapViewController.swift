//
//  TotalMapViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/26.
//

import UIKit
import GoogleMaps

class TotalMapViewController: UIViewController {
    
    weak var delegate : ChildViewControllerDelegate?
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var cnt : Int = 0
    var datas : CalculateResponse?
    var settingData : MapInfoResponse?
    var locationArray : [[LocationsData]] = []
    var sequences : [Int] = []
    var dates : [String] = []
    let pingColor : [UIColor] = [UIColor(hexString: "FF9292"),
                                 UIColor(hexString: "FFD392"),
                                 UIColor(hexString: "AEFF92"),
                                 UIColor(hexString: "92E5FF"),
                                 UIColor(hexString: "929DFF"),
                                 UIColor(hexString: "D692FF"),
                                 UIColor(hexString: "FF92EE")]
    let markerImages: [UIImage] = [
        UIImage(named: "day1")!,
        UIImage(named: "day2")!,
        UIImage(named: "day3")!,
        UIImage(named: "day4")!,
        UIImage(named: "day5")!,
        UIImage(named: "day6")!,
        UIImage(named: "day7")!
    ]
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ConTainView: UIView!
    @IBOutlet weak var MapTableView: UITableView!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLayoutSubviews() {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapTableView.delegate = self
        MapTableView.dataSource = self
        MapTableView.separatorStyle = .none
        
        TitleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        NextButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        NextButton.layer.cornerRadius = 24
        
        MapInfo {
            DispatchQueue.main.async {
                let days = self.settingData?.data?.days ?? []
                for day in days {
                    self.locationArray.append(day.locations)
                    self.sequences.append(day.sequence)
                }
                
                self.TitleLabel.text = self.settingData?.data?.title ?? "제목을 찾을 수 없습니다."
                
                let mapView = GMSMapView(frame: self.ConTainView.bounds)
                                
                do {
                    // style.json 파일은 프로젝트에 추가해야 합니다.
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }

                // 초기 위치 설정
                var bounds = GMSCoordinateBounds()

                for (dayIndex, locations) in self.locationArray.enumerated() {
                    var path = GMSMutablePath()
                    for (cordIndex, cord) in locations.enumerated() {
                        let lat = cord.coordinate?.latitude ?? 32.3
                        let log = cord.coordinate?.longitude ?? 32.3
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: log)
                        marker.title = cord.name

                        // 아이콘 이미지 생성
                        let baseImage = self.markerImages[dayIndex % self.markerImages.count]
                        let imageSize = baseImage.size
                        UIGraphicsBeginImageContextWithOptions(imageSize, false, baseImage.scale)
                        baseImage.draw(in: CGRect(origin: .zero, size: imageSize))

                        let markerNumber = "\(cordIndex + 1)" // 숫자로 표시할 cordIndex
                        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.white]
                        let textSize = markerNumber.size(withAttributes: attributes)
                        let textOrigin = CGPoint(x: (imageSize.width - textSize.width) / 2, y: (imageSize.height - textSize.height) / 2)
                        markerNumber.draw(at: textOrigin, withAttributes: attributes)

                        let newImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()

                        marker.icon = newImage
                        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        marker.map = mapView

                        path.add(marker.position) // 경로에 좌표 추가
                        bounds = bounds.includingCoordinate(marker.position)
                    }

                    let polyline = GMSPolyline(path: path)
                    polyline.strokeWidth = 2.0
                    polyline.strokeColor = .white
                    polyline.map = mapView
                }


                // 모든 마커를 포함하도록 카메라를 업데이트합니다.
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0) // 필요한 패딩을 추가하세요
                mapView.moveCamera(update)

                self.ConTainView.addSubview(mapView)
                
                if let days = self.settingData?.data?.days {
                    for day in days {
                        self.sequences.append(day.sequence)
                        self.dates.append(day.date)
                    }
                }
                self.MapTableView.reloadData()
            }
        }
    }
    
    @IBAction func TotalView(_ sender: UIButton) {
        delegate?.switchMaptoTotal()
    }
    
    
    @IBAction func HomeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let
            saveView = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            saveView.token = self.token
            saveView.id = self.id
            saveView.travelId = self.travelId
            saveView.datas = self.datas
            
            self.navigationController?.pushViewController(saveView, animated: true)
        }
        else {print("total 문제")}
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
    
    func alert(message : String) -> Bool {
        var result : Bool = false
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            result = true
        }

        alertVC.addAction(okAction)
        present(alertVC, animated: true)
        
        return result
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexInt = Int(hexString, radix: 16)!
        self.init(
            red: CGFloat((hexInt >> 16) & 0xFF) / 255.0,
            green: CGFloat((hexInt >> 8) & 0xFF) / 255.0,
            blue: CGFloat((hexInt) & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}

extension TotalMapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.sequences)
        print(self.dates)
        print(self.sequences.count)
        return self.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummuryMapCell", for: indexPath) as! SummuryMapCell

        print(indexPath.row)
        cell.DayImage.tintColor = self.pingColor[indexPath.row%7]
        cell.DayLabel.text = "Day " + String(indexPath.row + 1) + " "
        
        // Check if the custom font is available, otherwise use system font
        if let dayLabelFont = UIFont(name: "Pretendard-SemiBold", size: 16) {
            cell.DayLabel.font = dayLabelFont
        } else {
            cell.DayLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
        
        cell.DuringLabel.text = self.dates[indexPath.row]
        cell.DuringLabel.textColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        // Check if the custom font is available, otherwise use system font
        if let duringLabelFont = UIFont(name: "Pretendard-Medium", size: 13) {
            cell.DuringLabel.font = duringLabelFont
        } else {
            cell.DuringLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        
        return cell
    }

    
    
}

extension TotalMapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0
    }
}
