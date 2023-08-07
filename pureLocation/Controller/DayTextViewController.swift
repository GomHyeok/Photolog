//
//  DayTextViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit


enum TextViewType {
    case description
    case locationName
}

class DayTextViewController: UIViewController, UITextFieldDelegate {
    weak var delegate : ChildDelegate?
    
    var token : String = ""
    var id : Int = 0
    var travelId: Int = 0
    var datas : TravelInfoResponse?
    var output : CalculateResponse?
    var cnt : Int = 0
    var days : DayData?
    var locationId : [Int] = []
    var settingData : LocationInfoResponse?
    var urlArray : [[URL]] = []
    var fullAddress : [String] = []
    var placeNames : [String] = []
    var descriptions : [String] = []
    var st : String = ""
    var loadingView: UIView!
    var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var During: UILabel!
    @IBOutlet weak var TagTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagTable.delegate = self
        TagTable.dataSource = self
        
        Day.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        
        // Line height: 29 pt
        Day.attributedText = NSMutableAttributedString(string: "Day 1", attributes: [NSAttributedString.Key.kern: 1.2])
       
        During.font = UIFont(name: "Pretendard-Medium", size: 13)
        
        days = datas?.data?.days[self.cnt]
        if let locations = days?.locations {
            for location in locations {
                var arr : [URL] = []
                for url in location.photoUrls {
                    arr.append(URL(string: url)!)
                }
                urlArray.append(arr)
                locationId.append(location.id)
            }
        }
        self.Day.text = "Day "
        self.Day.text! += String(days?.sequence ?? 0)
        self.During.text = days?.date
        
        locationInfoSequentially(index: 0)
        
        let footerView = UIView(frame: CGRect(x: 22, y: 20, width: TagTable.frame.size.width-22, height: 53))
        let button = UIButton(frame: footerView.bounds)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor  = UIColor(red: 1, green: 0.44, blue: 0.26, alpha: 0.9)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        footerView.addSubview(button)
        TagTable.tableFooterView = footerView
    }
    
    func locationInfoSequentially(index: Int) {
        guard index < locationId.count else {
            DispatchQueue.main.async {
                self.TagTable.reloadData()
            }
            return
        }

        let id = locationId[index]
        locationInfo(locationId: id) {
            self.locationInfoSequentially(index: index + 1)
        }
    }
    
    @objc func buttonTapped() {
        let dispatchGroup = DispatchGroup()
        for i in 0..<locationId.count {
            let text = descriptions[i] // Modify this to fetch description from your data model
            let name = placeNames[i] // Modify this to fetch name from your data model
            dispatchGroup.enter()
            locationDescription(locationId: locationId[i], description: text) {
                self.locationName(locationId: self.locationId[i], title: name) {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.cnt+=1
            if(self.cnt >= self.datas?.data?.days.count ?? 0) {
                self.cnt-=1
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                if let
                    total = storyboard.instantiateViewController(withIdentifier: "ParentViewController") as? ParentViewController {
                    total.token = self.token
                    total.id = self.id
                    total.travelId = self.travelId
                    total.datas = self.output
                    
                    self.navigationController?.pushViewController(total, animated: true)
                }
                else {print("total 문제")}
            }
            else {
                self.urlArray = []
                self.locationId = []
                self.fullAddress = []
                self.placeNames = []
                self.descriptions = []
                self.days = self.datas?.data?.days[self.cnt]
                if let locations = self.days?.locations {
                    for location in locations {
                        var arr : [URL] = []
                        for url in location.photoUrls {
                            arr.append(URL(string: url)!)
                        }
                        self.urlArray.append(arr)
                        self.locationId.append(location.id)
                    }
                }
                self.Day.text = "Day "
                self.Day.text! += String(self.days?.sequence ?? 0)
                self.During.text = self.days?.date
                
                self.locationInfoSequentially(index: 0)
            }
        }
    }
    
    func showLoading() {
        loadingView = UIView()
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = UIColor(white: 0.5, alpha: 0.7) // 반투명 검은색 배경
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        // 스피너의 초기화
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loadingView.center
        spinner.startAnimating()
        loadingView.addSubview(spinner)
    }
    
    func hideLoading() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       textField.text = ""
       return true
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 특정 조건에 따라 글자 색을 변경합니다.
        if updatedText == "장소명을 입력해주세요" {
            textField.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha : 1.0)
        } else {
            textField.textColor = UIColor.black
        }

        return true
    }
}

extension DayTextViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 360 // 예시로 높이를 100으로 고정하였습니다.
    }
}

extension DayTextViewController : UITableViewDataSource, DayLogTextCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayLogTextCell", for: indexPath) as! DayLogTextCell
        cell.BackGroundImage.layer.cornerRadius = 12
        
        cell.data = urlArray[indexPath.row]
        if indexPath.row < placeNames.count {
            print(placeNames[indexPath.row])
            cell.LocationName.text = placeNames[indexPath.row]
        } else {
            cell.LocationName.text = "Loading..."
        }
        cell.LocationName.font = UIFont(name: "Pretendard-Medium", size: 24)
        if cell.LocationName.text == "장소명을 입력해주세요" {
            cell.LocationName.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha : 1.0)
        }
        else {
            cell.LocationName.textColor = UIColor.black
        }

        if indexPath.row < fullAddress.count {
            cell.PlaceName.text = fullAddress[indexPath.row]
        } else {
            cell.PlaceName.text = "Loadin16g..."
        }
        
        if indexPath.row < descriptions.count {
            print(descriptions[indexPath.row])
            cell.Description.text = descriptions[indexPath.row]
        } else {
            cell.Description.text = "Loading..."
        }
        cell.Description.font = UIFont(name: "Pretendard-Regular", size: 14)
        cell.token = self.token
        cell.locationId = self.locationId[indexPath.row]
        
        let PlaceNameFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let PlaceName: [NSAttributedString.Key: Any] = [
            .font: PlaceNameFont,
            .kern: 1.2,
        ]
        
        cell.PlaceName.attributedText = NSMutableAttributedString(string: cell.PlaceName.text ?? "", attributes: PlaceName)
        
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.setData(urlArray[indexPath.row])
        return cell
    }
    
    
    func didTapAIButton(in cell: DayLogTextCell) {
        // Handle button tap
        showLoading()
    }
    
    func didTapAIButtons(in cell: DayLogTextCell) {
        // Handle button tap
        hideLoading()
    }
    
    func textViewDidChange(text: String, type: TextViewType, at index: Int) {
        switch type {
        case .description:
            descriptions[index] = text
        case .locationName:
            placeNames[index] = text
        }
    }
}


extension DayTextViewController {
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        print("locationInfo")
        UserService.shared.locationInfo(locationId: locationId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? LocationInfoResponse else {return}
                        self.fullAddress.append(data.data?.fullAddress ?? "장소를 알 수 없습니다.")
                        self.placeNames.append(data.data?.name ?? "장소명을 입력해주세요")
                        self.descriptions.append(data.data?.description ?? "정보를 입력해주세요")
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
    
    func Review (locationId : Int, keyword : [String], completion : @escaping () -> Void) {
        UserService.shared.Review(token: token, locationId: locationId, keyword: keyword) {
                response in
            switch response {
                case .success(let data) :
                    guard let data = data as? staticResponse else {return}
                    self.st = data.message
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

extension DayTextViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "정보를 입력해주세요" {
            textView.text = ""
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "정보를 입력해주세요" {
            textView.text = ""
        }
        return true
    }
}


