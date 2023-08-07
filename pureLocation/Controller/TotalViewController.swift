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
        InfoTable.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InfoTable.dataSource = self
        InfoTable.delegate = self
        
        travelInfo {
            DispatchQueue.main.async {
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
            cell.Days.text = "Day " + String(self.sequences[indexPath.section])
            let daysFont = UIFont(name: "Pretendard-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24)
            let daysAttributes: [NSAttributedString.Key: Any] = [
                .font: daysFont,
                .kern: 0.2
            ]
            cell.Days.attributedText = NSMutableAttributedString(string: cell.Days.text!, attributes: daysAttributes)

            let duringFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
            let duringAttributes: [NSAttributedString.Key: Any] = [
                .font: duringFont,
                .kern: 0.2
            ]
            cell.During.text = self.dates[indexPath.section]
            cell.During.attributedText = NSMutableAttributedString(string: cell.During.text!, attributes: duringAttributes)

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalTableViewCell", for: indexPath) as! TotalTableViewCell

            cell.PlaceName?.text = locationArray[indexPath.section][indexPath.row-1].name ?? ""
            cell.PlaceName.textColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
            let placeNameFont = UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
            let placeNameAttributes: [NSAttributedString.Key: Any] = [
                .font: placeNameFont,
                .kern: 1.2
            ]
            cell.PlaceName?.attributedText = NSMutableAttributedString(string: cell.PlaceName?.text ?? "", attributes: placeNameAttributes)

            let urlString = self.locationArray[indexPath.section][indexPath.row-1].photoUrls[0]
            let url = URL(string: urlString)!
            
            var totalCellCount = 0
            
            for section in 0..<indexPath.section {
                let rowCount = tableView.numberOfRows(inSection: section)
                totalCellCount += rowCount
            }
            totalCellCount += indexPath.row-1
            
            cell.ButtonImage.load(url: url)
            cell.ButtonImage.layer.cornerRadius = 8
            
            cell.cellButton.tag = indexPath.section
            
            cell.ButtonLabel.text = locationArray[indexPath.section][indexPath.row-1].description ?? ""
            cell.ButtonLabel.textColor = UIColor(red: 0.426, green: 0.426, blue: 0.426, alpha: 1)
            let buttonLabelFont = UIFont(name: "Pretendard-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
            var text = cell.ButtonLabel.text!

            let fontSize: CGFloat = 12
            let lineHeightPercent: CGFloat = 1.63 // 163% = 1.63 in decimal
            let lineSpacing: CGFloat = fontSize * lineHeightPercent - fontSize

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.37
            paragraphStyle.lineSpacing = lineSpacing

            let buttonLabelAttributes: [NSAttributedString.Key: Any] = [
                .font: buttonLabelFont,
                .kern: 0.36,
                .paragraphStyle: paragraphStyle
            ]
            cell.ButtonLabel.attributedText = NSMutableAttributedString(string: text, attributes: buttonLabelAttributes)

            cell.BackGroundImage.layer.cornerRadius = 16

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
            return 75
        }
        else {
            return 205.0
        }
    }
    
}
