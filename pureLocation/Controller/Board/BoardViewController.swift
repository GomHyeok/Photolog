
import UIKit
import GoogleMaps

class BoardViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var ArticleId : Int = 0
    var likeStatus : Bool = false
    var bookmarkStatus : Bool = false
    var settingData : ArticleInfoResponse?
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
    
    @IBOutlet weak var TravelTable: UITableView!
    
    @IBOutlet weak var BookImg: UIImageView!
    @IBOutlet weak var HartImg: UIImageView!
    @IBOutlet weak var BookButton: UIButton!
    @IBOutlet weak var HartButton: UIButton!
    @IBOutlet weak var BookNum: UILabel!
    @IBOutlet weak var HartNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        

        BookNum.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        BookNum.font = UIFont(name: "Pretendard-Medium", size: 13)
        
        HartNum.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        HartNum.font = UIFont(name: "Pretendard-Medium", size: 13)

        let button = UIButton(type: .system)
        if let menuImage = UIImage(named: "reportMenu")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(menuImage, for: .normal)
            button.showsMenuAsPrimaryAction = true
            button.menu = createMenu()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
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
            self.likeStatus = self.settingData?.data?.likeStatus ?? false
            self.bookmarkStatus = self.settingData?.data?.bookmarkStatus ?? false
            if(self.likeStatus) {
                self.HartImg.image = UIImage(named: "blackHart")
            }
            else {
                self.HartImg.image = UIImage(named: "articleHeart")
            }
            if(self.bookmarkStatus) {
                self.BookImg.image = UIImage(named: "blackBook")
            }
            else {
                self.BookImg.image = UIImage(named: "book")
            }
            self.TravelTable.reloadData()
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    func createMenu() -> UIMenu {
        let action1 = UIAction(title: "신고하기", image: UIImage(named: "report")) { action in
            self.check(message: "게시물을 신고하시겠습니까?")
        }

        let menu = UIMenu(title: "", children: [action1])
        return menu
    }
    
    
    @IBAction func LikeButton(_ sender: Any) {
        if likeStatus {
            likeCancle()
            likeStatus = false
            HartImg.image = UIImage(named: "hart")
            self.settingData?.data?.likes -= 1
        }
        else {
            like()
            likeStatus = true
            HartImg.image = UIImage(named: "blackHart")
            self.settingData?.data?.likes += 1
        }
        self.HartNum.text! = String(self.settingData?.data?.likes ?? 0)
    }
    
    
    @IBAction func BookMark(_ sender: Any) {
        if bookmarkStatus {
            bookmarkCancle()
            bookmarkStatus = false
            BookImg.image = UIImage(named: "bookmark")
            
            self.settingData?.data?.bookmarks -= 1
        }
        else {
            bookmark()
            bookmarkStatus = true
            BookImg.image = UIImage(named: "blackBook")
            
            self.settingData?.data?.bookmarks += 1
        }
        self.BookNum.text! = String(self.settingData?.data?.bookmarks ?? 0)
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
            cell.Title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.Title.font = UIFont(name: "Pretendard-SemiBold", size: 24)


            cell.Location.text = self.settingData?.data?.days?[0].locations?[0].city
            cell.Location.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.Location.font = UIFont(name: "Pretendard-Regular", size: 14)

            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.kern: -0.28
            ]
            cell.Location.attributedText = NSMutableAttributedString(string: cell.Location.text ?? "", attributes: attributes)

            cell.Creator.text = "By. "
            cell.Creator.text! += self.settingData?.data?.nickname ?? ""
            cell.Creator.font = UIFont(name: "Pretendard-Regular", size: 14)
            cell.Creator.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

            cell.Descript.text = self.settingData?.data?.summary ?? ""
            cell.Descript.textColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
            cell.Descript.font = UIFont(name: "Pretendard-Regular", size: 14)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.48

            let descriptAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.kern: 0.84,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            cell.Descript.attributedText = NSMutableAttributedString(string: cell.Descript.text ?? "", attributes: descriptAttributes)

            
            // 이미지 로드
            let imageUrl = URL(string: self.settingData?.data?.days?[0].locations?[0].photoUrls[0] ?? "")
            cell.TableImage.kf.setImage(with: imageUrl)

            
            // 그래디언트 뷰 생성 및 설정
            let gradientView = UIView()
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
            gradientLayer.locations = [0.5, 1.0]
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
            cell.TableImage.addSubview(gradientView)
            cell.gradientView = gradientView  // 셀의 그라디언트 뷰 프로퍼티에 할당

            
            
            return cell
        }
        else if indexPath.section == (self.settingData?.data?.days?.count ?? 0) + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardBudget", for: indexPath) as! BoardBudget
            cell.BudgetLabel.text = "총 "
            cell.BudgetLabel.text! += String(settingData?.data?.budget ?? 0)
            cell.BudgetLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.BudgetLabel.font = UIFont(name: "Pretendard-Bold", size: 16)

            cell.GroupMemeber.text = self.settingData?.data?.member ?? "구성원이 입력되지 않았습니다."
            cell.GroupMemeber.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.GroupMemeber.font = UIFont(name: "Pretendard-Bold", size: 16)

            
            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
                let mapView = GMSMapView(frame: cell.ContainerView.bounds)
                var path = GMSMutablePath()  // 경로 생성
                var bounds = GMSCoordinateBounds() // 경계 생성
                
                let locations = self.settingData?.data?.days?[indexPath.section-1].locations ?? []
                mapView.camera = GMSCameraPosition.camera(withLatitude: locations.first?.coordinate.latitude ?? 32.3, longitude: locations.first?.coordinate.longitude ?? 32.3, zoom: 9.0)

                for (cordIndex, cord) in locations.enumerated() {
                    let lat = cord.coordinate.latitude
                    let log = cord.coordinate.longitude
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: log)
                    marker.title = cord.name

                    let baseImage = self.markerImages[indexPath.section-1 % self.markerImages.count]
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
                
                if "" == self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].name {
                    cell.LocationTitle.text = "이름을 입력해주세요"
                }
                else {
                    cell.LocationTitle.text = self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].name
                }
                
                cell.LocationTitle.font = UIFont(name: "Pretendard-SemiBold", size: 16)
                
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
                
                let descriptionsFont = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
                let descriptionsAttributes: [NSAttributedString.Key: Any] = [
                    .font: descriptionsFont,
                    .kern: 1.2,
                    .foregroundColor: UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
                ]
                cell.Descriptions.attributedText = NSMutableAttributedString(string: cell.Descriptions.text ?? "", attributes: descriptionsAttributes)
                
                cell.FullAddress.text = self.settingData?.data?.days?[indexPath.section-1].locations?[indexPath.row-1].degree ?? ""
                
                let fullAddressFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
                let fullAddressAttributes: [NSAttributedString.Key: Any] = [
                    .font: fullAddressFont,
                    .kern: 1.2,
                    .foregroundColor: UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1)
                ]
                cell.FullAddress.attributedText = NSMutableAttributedString(string: cell.FullAddress.text ?? "", attributes: fullAddressAttributes)
                
                cell.setData(cell.data)
                cell.LocationCount.text! = String(indexPath.row)
                cell.LocationCount.font = UIFont(name: "Pretendard-Bold", size: 12)
                
                cell.PingImage.tintColor = self.pingColor[(indexPath.section-1)%7]
                
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
            return 360.0
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
    
    func articleReport (completion : @escaping () -> Void) {
        UserService.shared.ArticleReport(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 신고할 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func check(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "신고", style: .default) {_ in
            self.articleReport {
                self.alert(message: "게시물을 신고하였습니다.")
            }
        }
        
        let cancle = UIAlertAction(title: "취소", style: .default)
        alertVC.addAction(okAction)
        alertVC.addAction(cancle)
        present(alertVC, animated: true)
    }
    
    func like() {
        UserService.shared.like(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글 좋아요 선택")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 좋아요를 누를 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func likeCancle() {
        UserService.shared.likeCancle(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글 좋아요 취소")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 좋아요를 누를 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func bookmark() {
        UserService.shared.bookmark(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글이 북마크 되었습니다.")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 북마크 할 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func bookmarkCancle() {
        UserService.shared.bookmarkCancle(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글이 북마크 해제되었습니다.")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 북마크 할 수 없어요")
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
