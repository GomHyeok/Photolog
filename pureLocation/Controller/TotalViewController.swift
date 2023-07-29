//
//  TotalViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/19.
//

import UIKit

class TotalViewController: UIViewController {
    
    weak var delegate : ChildViewControllerDelegate?
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var settingData : TravelInfoResponse?
    var sequences : [Int] = []
    var locationArray : [[LocationData]] = []
    var dates : [String] = []
    
    @IBOutlet weak var InfoTable: UITableView!
    @IBOutlet weak var TravelTitle: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InfoTable.dataSource = self
        InfoTable.delegate = self
        TravelTitle.font = UIFont(name: "Pretendard-Bold", size: 20)
        
        NextButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        NextButton.layer.cornerRadius = 10
        
        travelInfo {
            DispatchQueue.main.async {
                self.TravelTitle.text = self.settingData?.data?.title ?? "여행 제목을 찾을 수 없습니다."
                let days = self.settingData?.data?.days ?? []
                
                for day in days {
                    self.dates.append(day.date)
                    self.sequences.append(day.sequence)
                    self.locationArray.append(day.locations)
                }
            }
            
            DispatchQueue.main.async{
                self.InfoTable.reloadData()
            }
        }
        
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
    
    
    @IBAction func MapButton(_ sender: UIButton) {
        delegate?.switchTotaltToMap()
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let homeView = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeView.token = self.token
            homeView.id = self.id
            homeView.travelId = self.travelId
            
            self.navigationController?.pushViewController(homeView, animated: true)
        }
        else {print("home 문제")}
    }
    
}

extension TotalViewController {
    func travelInfo(completion : @escaping () -> Void) {
        UserService.shared.travelInfo(travelId: travelId, token: token) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? TravelInfoResponse else {return}
                        self.settingData = data
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
    
    func alert(message : String) -> Bool {
        var result : Bool = false
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            result = true
        }
        let cancleAction = UIAlertAction(title: "취소", style: .default)

        alertVC.addAction(okAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true)
        
        return result
    }
}

extension TotalViewController : UITableViewDataSource {
    
    //section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sequences.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dayscell", for: indexPath) as! Dayscell
            cell.Days.text = "Day" + String(self.sequences[indexPath.section])
            cell.Days.font = UIFont(name: "Pretendard-Bold", size: 24)
            
            cell.During.text = self.dates[indexPath.section]
            cell.During.font = UIFont(name : "Pretendard-Regular", size: 13)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalTableViewCell", for: indexPath) as! TotalTableViewCell
            
            cell.PlaceName?.text = locationArray[indexPath.section][indexPath.row-1].name ?? ""
            cell.PlaceName.font = UIFont(name: "Pretendard-Bold", size: 16)
            
            let urlString = self.locationArray[indexPath.section][indexPath.row-1].photoUrls[0]
            let url = URL(string: urlString)!
            
            var totalCellCount = 0
            
            for section in 0..<indexPath.section {
                let rowCount = tableView.numberOfRows(inSection: section)
                totalCellCount += rowCount
            }
            totalCellCount += indexPath.row-1
            
            cell.cellButton.tag = indexPath.section
            cell.ButtonImage.load(url: url)
            cell.ButtonLabel.text = locationArray[indexPath.section][indexPath.row-1].description ?? ""
            cell.ButtonLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            
            
            cell.cellButton.addTarget(self, action: #selector(cellaction(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func cellaction(_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let daylog = storyboard.instantiateViewController(withIdentifier: "DayLogParentViewController") as? DayLogParentViewController {
            daylog.token = self.token
            daylog.id = self.id
            daylog.travelId = self.travelId
            daylog.datas = self.datas
            daylog.cnt = sender.tag
            
            self.navigationController?.pushViewController(daylog, animated: true)
        }
        else {print("summary 문제")}
    }
}

extension TotalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        else {
            return 230.0
        }
    }
    
}
