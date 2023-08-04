//
//  DayTagViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit

class DayTagViewController: UIViewController {
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
    

    @IBOutlet weak var BottomLine: UIView!
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var TagTable: UITableView!
    @IBOutlet weak var DayView: UIView!
    @IBOutlet weak var During: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.cnt)
        
        TagTable.delegate = self
        TagTable.dataSource = self
        
        Day.font = UIFont(name: "Pretendard-Bold", size: 24)
        During.font = UIFont(name: "Pretendard-Regular", size: 13)
        
        days = datas?.data?.days[cnt]
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
        
        BottomLine.setBottomLines(borderColor: UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0), hight: 1.0, bottom: 0)
        
        
        locationInfoSequentially(index: 0)
        
        let footerView = UIView(frame: CGRect(x: 20, y: 0, width: TagTable.frame.size.width-20, height: 53))
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
            let cell = TagTable.cellForRow(at: indexPath) as! DayLogTagCell
            let text = cell.LocationName.text!
            dispatchGroup.enter()
            locationName(locationId: locationId[i], title: text) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.delegate?.tagToText(cnt: self.cnt)
        }
    }
    
    @objc func buttonTapped() {
        let dispatchGroup = DispatchGroup()
        for i in 0..<locationId.count {
            let indexPath = IndexPath(row: i, section: 0) // change these numbers to the index of the cell you want
            let cell = TagTable.cellForRow(at: indexPath) as! DayLogTagCell
            let text = cell.LocationName.text!
            dispatchGroup.enter()
            locationName(locationId: locationId[i], title: text) {
                dispatchGroup.leave()
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


extension UIImageView {
    func load(url : URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}

extension DayTagViewController {
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        UserService.shared.locationInfo(locationId: locationId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? LocationInfoResponse else {return}
                        print(data)
                        self.fullAddress.append(data.data?.fullAddress ?? "장소를 알 수 없습니다.")
                        self.placeNames.append(data.data?.name ?? "이름을 입력해주세요")
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

extension DayTagViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 370
    }
}

extension DayTagViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayLogTagCell", for: indexPath) as! DayLogTagCell
        
        cell.data = urlArray[indexPath.row]
        if indexPath.row < placeNames.count {
            cell.LocationName.text = placeNames[indexPath.row]
        } else {
            cell.LocationName.text = "Loading..."
        }
        cell.LocationName.font = UIFont(name: "Pretendard-Bold", size: 24)
        cell.LocationName.delegate = self

        if indexPath.row < fullAddress.count {
            cell.PlaceName.text = fullAddress[indexPath.row]
        } else {
            cell.PlaceName.text = "Loading..."
        }
        cell.PlaceName.font = UIFont(name: "Pretendard-Regular", size: 13)
        
        cell.Places.setBottomLines(borderColor: UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0), hight: 1.0, bottom: 0)
        
        cell.setData(urlArray[indexPath.row])
        return cell
    }
}

extension UIView {
    func setBottomLines(borderColor: UIColor, hight : Double, bottom : CGFloat) {
          self.backgroundColor = UIColor.clear
          let borderLine = UIView()
          borderLine.frame = CGRect(x: 0, y: Double(self.frame.height + bottom), width: Double(self.frame.width), height: hight)
          borderLine.backgroundColor = borderColor
          self.addSubview(borderLine)
     }
}

extension DayTagViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear the existing text of the text field
        textField.text = ""
    }
}
