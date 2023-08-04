//
//  DayTextViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit

class DayTextViewController: UIViewController {
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
    
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var During: UILabel!
    @IBOutlet weak var TagTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagTable.delegate = self
        TagTable.dataSource = self
        
        Day.font = UIFont(name: "Pretendard-Bold", size: 24)
        During.font = UIFont(name: "Pretendard-Regular", size: 13)
        
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
        self.Day.text = "Day"
        self.Day.text! += String(days?.sequence ?? 0)
        self.During.text = days?.date
        
        locationInfoSequentially(index: 0)
        
        let footerView = UIView(frame: CGRect(x: 30, y: 0, width: TagTable.frame.size.width-40, height: 53))
        let button = UIButton(frame: footerView.bounds)
        button.setTitle("다음", for: .normal)
        button.backgroundColor  = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1.0)
        button.layer.cornerRadius = 24
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        footerView.addSubview(button)
        TagTable.tableFooterView = footerView
    }
    
    func locationInfoSequentially(index: Int) {
        guard index < locationId.count else {
            DispatchQueue.main.async {
                print("reload")
                print(self.fullAddress)
                print(self.placeNames)
                self.TagTable.reloadData()
            }
            return
        }

        let id = locationId[index]
        print(id)
        locationInfo(locationId: id) {
            self.locationInfoSequentially(index: index + 1)
        }
    }
    
    
    @IBAction func SwitchButton(_ sender: UIButton) {
        let dispatchGroup = DispatchGroup()
        for i in 0..<locationId.count {
            let indexPath = IndexPath(row: i, section: 0) // change these numbers to the index of the cell you want
            let cell = TagTable.cellForRow(at: indexPath) as! DayLogTextCell
            let text = cell.Description.text!
            let name = cell.PlaceName.text!
            dispatchGroup.enter()
            locationDescription(locationId: locationId[i], description: text) {
                self.locationName(locationId: self.locationId[i], title: name) {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.delegate?.textToTag(cnt: self.cnt)
        }
    }
    
    @objc func buttonTapped() {
        let dispatchGroup = DispatchGroup()
        for i in 0..<locationId.count {
            let indexPath = IndexPath(row: i, section: 0) // change these numbers to the index of the cell you want
            let cell = TagTable.cellForRow(at: indexPath) as! DayLogTextCell
            let text = cell.Description.text!
            let name = cell.PlaceName.text!
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
                self.viewDidLoad()
            }
        }
    }
}

extension DayTextViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400.0 // 예시로 높이를 100으로 고정하였습니다.
    }
}

extension DayTextViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayLogTextCell", for: indexPath) as! DayLogTextCell
        
        cell.data = urlArray[indexPath.row]
        if indexPath.row < placeNames.count {
            print(placeNames[indexPath.row])
            cell.LocationName.text = placeNames[indexPath.row]
        } else {
            cell.LocationName.text = "Loading..."
        }
        cell.LocationName.font = UIFont(name: "Pretendard-Bold", size: 24)

        if indexPath.row < fullAddress.count {
            print(fullAddress[indexPath.row])
            cell.PlaceName.text = fullAddress[indexPath.row]
        } else {
            cell.PlaceName.text = "Loading..."
        }
        cell.PlaceName.font = UIFont(name: "Pretendard-Regular", size: 13)
        
        if indexPath.row < descriptions.count {
            print(descriptions[indexPath.row])
            cell.Description.text = descriptions[indexPath.row]
        } else {
            cell.Description.text = "Loading..."
        }
        cell.Description.font = UIFont(name: "Pretendard-Regular", size: 14)
        cell.Description.delegate = self
        
        
        cell.setData(urlArray[indexPath.row])
        return cell
    }
}


extension DayTextViewController {
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        UserService.shared.locationInfo(locationId: locationId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? LocationInfoResponse else {return}
                        print(data)
                        self.fullAddress.append(data.data?.fullAddress ?? "장소를 알 수 없습니다.")
                        self.placeNames.append(data.data?.name ?? "이름을 입력해주세요")
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
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

extension DayTextViewController : UITextViewDelegate {
    func textFieldDidBeginEditing(_ textView: UITextView) {
        // Clear the existing text of the text field
        textView.text = ""
    }
}
