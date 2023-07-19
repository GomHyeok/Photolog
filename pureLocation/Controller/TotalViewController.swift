//
//  TotalViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/19.
//

import UIKit

class TotalViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var settingData : TravelInfoResponse?
    var sequences : [Int] = []
    var locationArray : [[LocationData]] = []
    
    @IBOutlet weak var InfoTable: UITableView!
    @IBOutlet weak var TravelTitle: UILabel!
    
    override func viewDidLayoutSubviews() {
        travelInfo {
            DispatchQueue.main.async {
                self.TravelTitle.text = self.settingData?.data?.title ?? "여행 제목을 찾을 수 없습니다."
                let days = self.settingData?.data?.days ?? []
                for day in days {
                    self.sequences.append(day.sequence)
                    self.locationArray.append(day.locations)
                }
            }
            
            DispatchQueue.main.async{
                self.InfoTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InfoTable.dataSource = self
        InfoTable.delegate = self
    }
    
    @IBAction func HomeButton(_ sender: UIButton) {
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
}

extension TotalViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let st = String(self.sequences[section]) + "일차"
        return st
    }
    
    //section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sequences.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalTableViewCell", for: indexPath) as! TotalTableViewCell
        
        cell.PlaceName?.text = locationArray[indexPath.section][indexPath.row].name ?? ""
        let urlString = self.locationArray[indexPath.section][indexPath.row].photoUrls[0]
        let url = URL(string: urlString)!
        
        cell.ButtonImage.load(url: url)
        cell.ButtonLabel.text = locationArray[indexPath.section][indexPath.row].description ?? ""
        
        
        return cell
    }
}

extension TotalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200.0
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            
            let label = UILabel()
            label.textColor = UIColor.init(red: 0.33, green: 0.33, blue: 0.34, alpha: 1.0) // 텍스트 색상 설정
            label.font = UIFont.boldSystemFont(ofSize: 20) // 폰트 크기 및 스타일 설정
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
