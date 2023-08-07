//
//  MapViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/21.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var TravelTitle: UILabel!
    @IBOutlet weak var TravelMapTable: UITableView!
    @IBOutlet weak var ContentFiled: UITextView!
    @IBOutlet weak var BottomLine: UIView!
    
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
    var citys : [[String]] = []
    var urlArray : [[[URL]]] = []
    var fullAddress : [String] = []
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = CGFloat(0.5)
        
        // 하단에 경계선을 추가
        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
        bottomBorder.frame = CGRect(x: 0, y: BottomLine.frame.size.height - width, width:  BottomLine.frame.size.width+20, height: width)
        bottomBorder.borderWidth = width
        BottomLine.layer.addSublayer(bottomBorder)
        
        self.navigationController?.isNavigationBarHidden = false
        
        var text = self.ContentFiled.text!
        self.ContentFiled.delegate = self

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.48

        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 0.84, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        self.ContentFiled.attributedText = attributedString
        self.ContentFiled.textColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        self.ContentFiled.font = UIFont(name: "Pretendard-Regular", size: 14)
        self.ContentFiled.setBottomLines(borderColor: UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0), hight: 0.5, bottom: 0)

    
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let saveButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(saveButtonAction))
        saveButton.tintColor = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1)
        navigationItem.rightBarButtonItem = saveButton
        
        TravelTitle.textColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
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
                var city : [String] = []
                self.locationArray.append(day.locations)
                self.sequences.append(day.sequence)
                for location in day.locations {
                    city.append(location.city)
                }
                self.citys.append(city)
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
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {
        let lastSectionIndex = TravelMapTable.numberOfSections - 1 // 마지막 섹션의 인덱스
        let lastRowIndex = TravelMapTable.numberOfRows(inSection: lastSectionIndex) - 1
        
        var budget : Int = 0
        var member : String = ""
        let indexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        if let cell = TravelMapTable.cellForRow(at: indexPath) as? BudgetCell {
            budget = cell.getBudget()
            member = cell.getGroup()
            
        } else {
            self.alert(message: "예산을 선택해주세요")
        }
        
        makeArticle(budget: budget, member: member) {
            self.navigationController?.popViewController(animated: true)
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let homeView = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController {
                
                homeView.token = self.token
                homeView.id = self.id
                
                homeView.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(homeView, animated: true)
            }
            else {print("홈뷰 문제")}
        }
    }
    
    func setLineSpacing(_ spacing: CGFloat, text: String) -> NSAttributedString {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = spacing
        
      return NSAttributedString(
        string: text,
        attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
      )
    }
    
    func textViewDidChange(_ textView: UITextView) {
            let cursorPosition = textView.selectedRange // 현재 커서 위치를 저장

            // 줄간격 적용
            textView.attributedText = setLineSpacing(10.0, text: textView.text)

            // 커서 위치 복원
            textView.selectedRange = cursorPosition
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
    
    func makeArticle (budget : Int, member : String, completion : @escaping () -> Void) {
        UserService.shared.makeArticle(token: token, travelId: travelId, title: self.TravelTitle.text!, summary: self.ContentFiled.text, locationContent: self.locationContent, budget: budget, member: member){
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
        return 50.0
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
            cell.Groups.font =  UIFont(name: "Pretendard-Medium", size: 20)
            cell.Budget.font =  UIFont(name: "Pretendard-Medium", size: 20)
            
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
                
                let mapView = GMSMapView(frame: cell.ContainerView.bounds)
                var path = GMSMutablePath()  // 경로 생성
                var bounds = GMSCoordinateBounds() // 경계 생성
                
                mapView.camera = GMSCameraPosition.camera(withLatitude: self.locationArray[indexPath.section][0].coordinate?.latitude ?? 32.3, longitude: self.locationArray[indexPath.section][0].coordinate?.longitude ?? 32.3, zoom: 9.0)
                
                for (cordIndex, cord) in locationArray[indexPath.section].enumerated() {
                    let lat = cord.coordinate?.latitude
                    let log = cord.coordinate?.longitude
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: lat ?? 32.3, longitude: log ?? 32.3)
                    marker.title = cord.name

                    let baseImage = self.markerImages[indexPath.section % self.markerImages.count]
                    let imageSize = baseImage.size
                    UIGraphicsBeginImageContextWithOptions(imageSize, false, baseImage.scale)
                    baseImage.draw(in: CGRect(origin: .zero, size: imageSize))

                    let markerNumber = "\(cordIndex + 1)"
                    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.white]
                    let textSize = markerNumber.size(withAttributes: attributes)
                    let textOrigin = CGPoint(x: (imageSize.width - textSize.width) / 2, y: (imageSize.height - textSize.height) / 2)
                    markerNumber.draw(at: textOrigin, withAttributes: attributes)

                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()

                    marker.icon = newImage
                    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)  // 마커 중앙이동
                    marker.map = mapView

                    path.add(marker.position)  // 마커 위치를 경로에 추가
                    bounds = bounds.includingCoordinate(marker.position) // 경계 업데이트
                }
                
                // 경로를 지도에 추가
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 2.0
                polyline.strokeColor = .white
                polyline.map = mapView

                // 모든 마커를 포함하도록 카메라를 업데이트합니다.
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                mapView.moveCamera(update)

                cell.ContainerView.addSubview(mapView)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationInfoCell", for: indexPath) as! LocationInfoCell
                
                if "" == locationArray[indexPath.section][indexPath.row-1].name {
                    cell.LocationTitle.text = "이름을 입력해주세요"
                }
                else {
                    cell.LocationTitle.text = locationArray[indexPath.section][indexPath.row-1].name
                }
                
                cell.LocationTitle.font = UIFont(name: "Pretendard-SemiBold", size: 16)
                
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
                
                cell.setData(urlArray[indexPath.section][indexPath.row-1])
                cell.PingImage.tintColor = pingColor[indexPath.section%7]
                cell.LocationCount.text! = String(indexPath.row)
                cell.LocationCount.font = UIFont(name: "Pretendard-Bold", size: 12)
                
                let descriptionsFont = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
                let descriptionsAttributes: [NSAttributedString.Key: Any] = [
                    .font: descriptionsFont,
                    .kern: 1.2,
                    .foregroundColor: UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
                ]
                cell.Descriptions.attributedText = NSMutableAttributedString(string: cell.Descriptions.text ?? "", attributes: descriptionsAttributes)

                cell.FullAddress.text = citys[indexPath.section][indexPath.row-1]
                let fullAddressFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
                let fullAddressAttributes: [NSAttributedString.Key: Any] = [
                    .font: fullAddressFont,
                    .kern: 1.2,
                    .foregroundColor: UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1)
                ]
                cell.FullAddress.attributedText = NSMutableAttributedString(string: cell.FullAddress.text ?? "", attributes: fullAddressAttributes)
                
                return cell
            }

        }
    }
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == locationArray.count{
            return 230.0
        }
        if indexPath.row == 0 {
            return 200.0
        }
        else {
            return 337.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < locationArray.count {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.white
            
            // 첫 번째 레이블을 생성하고 설정합니다.
            let label1 = UILabel()
            label1.frame = CGRect(x: 24, y: 0, width: tableView.frame.width, height: 50)
            let label1Font = UIFont(name: "Pretendard-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
            let label1Attributes: [NSAttributedString.Key: Any] = [
                .font: label1Font,
                .kern: 1.2,
                .foregroundColor: UIColor.black
            ]
            label1.attributedText = NSMutableAttributedString(string: "Day " + String(self.sequences[section]), attributes: label1Attributes)

            // 두 번째 레이블을 생성하고 설정합니다.
            let label2 = UILabel()
            label2.frame = CGRect(x: 88, y: 0, width: tableView.frame.width, height: 50)
            let label2Font = UIFont(name: "Pretendard-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
            let label2Attributes: [NSAttributedString.Key: Any] = [
                .font: label2Font,
                .kern: 1.2,
                .foregroundColor: UIColor.gray
            ]
            label2.attributedText = NSMutableAttributedString(string: self.settingData?.data?.days[section].date ?? "", attributes: label2Attributes)
            
            // 각 레이블을 headerView에 추가합니다.
            headerView.addSubview(label1)
            headerView.addSubview(label2)
            
            return headerView
        }
        else {
            return nil
        }
    }

}

extension MapViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear the existing text of the text field
        textField.text = ""
    }
}
