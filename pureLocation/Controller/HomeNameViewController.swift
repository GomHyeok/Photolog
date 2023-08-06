//
//  HomeNameViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/26.
//

import UIKit
import Photos
import BSImagePicker
import Kingfisher

class HomeNameViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var travelId = 0
    var log : Double = 0
    var lat : Double = 0
    var dateTime : String = ""
    var level1 : String = ""
    var formatted : String = ""
    var assets : [PHAsset] = []
    var imgs : [UIImage] = []
    var currentAssetIndex : Int = 0
    var assetsCount : Int = 0
    var data : CalculateResponse?
    var homeData : TravelAPIResponse?
    var check = true
    
    
    @IBOutlet weak var HomeTabelView: UITableView!
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        allView.backgroundColor = UIColor.clear
//        let borderLine = UIView()
//        borderLine.frame = CGRect(x: 0, y: Double(allView.frame.height), width: Double(allView.frame.width), height: 0.3)
//        borderLine.backgroundColor = lineColor2
//        allView.addSubview(borderLine)
        
        HomeTabelView.delegate = self
        HomeTabelView.dataSource = self
    }
    
    

}


extension HomeNameViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNameCell", for: indexPath) as! HomeNameCell
        
        cell.ButtonImage.kf.setImage(with: URL(string : homeData?.data[indexPath.item].thumbnail ?? "")!)
        cell.ButtonImage.layer.cornerRadius = cell.ButtonImage.frame.width/15
        
        cell.During.text = self.homeData?.data[indexPath.row].startDate
        cell.During.text! += "~"
        cell.During.text! += self.homeData?.data[indexPath.row].endDate ?? ""
        cell.During.font = UIFont(name : "Pretendard-Regular", size: 13)
        
        cell.Title.text = self.homeData?.data[indexPath.row].title
        cell.Title.font = UIFont(name : "Pretendard-Bold", size: 16)
        
        cell.Location.text = self.homeData?.data[indexPath.row].city
        cell.Location.font = UIFont(name : "Pretendard-Regular", size: 10)
        cell.Location.tintColor = UIColor(red: 185/255, green: 188/255, blue: 190.255, alpha: 1.0)
        let border = CALayer()
        let width = CGFloat(0.2)
        border.borderColor = UIColor(red: 0.46, green: 0.46, blue: 0.48, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y:cell.Location.frame.size.height - width, width: cell.Location.frame.size.width, height: width)
        border.borderWidth = width
        cell.Location.layer.addSublayer(border)
        cell.Location.layer.masksToBounds = true
        
        
        cell.ImageCnt.text = String(self.homeData?.data[indexPath.row].photoCnt ?? 0)
        cell.ImageCnt.font = UIFont(name : "Pretendard-Bold", size: 11)
        
        cell.ImageCnt.layer.cornerRadius = cell.ImageCnt.frame.width / 10
        
        cell.TabelButton.tag = indexPath.row
        cell.TabelButton.addTarget(self, action: #selector(cellaction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func cellaction(_ sender : UIButton) {
        print(self.homeData?.data[sender.tag].travelId ?? 0)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let daylog = storyboard.instantiateViewController(withIdentifier: "ParentViewController") as? ParentViewController {
            daylog.token = self.token
            daylog.id = self.id
            daylog.travelId = self.homeData?.data[sender.tag].travelId ?? 0
            daylog.datas = self.data
            daylog.check = true
            self.navigationController?.pushViewController(daylog, animated: true)
        }
        else {print("summary 문제")}
    }
    
}

extension HomeNameViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 145.0 // 예시로 높이를 100으로 고정하였습니다.
    }
}

