//
//  HomeViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit
import Photos
import BSImagePicker
import Kingfisher

class HomeViewController: UIViewController {
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
    var data : CalculateResponse?
    var homeData : TravelAPIResponse?
    var currentAssetIndex : Int = 0
    var assetsCount : Int = 0
    
    @IBOutlet weak var HomeTable: UITableView!


    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviews()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let lineColor = UIColor(red:255/255, green:112/255, blue:66/255, alpha:1.0)
        
        HomeTable.dataSource = self
        HomeTable.delegate = self
        
    }
}
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.HomeImageButton.tag = indexPath.row
        cell.buttonImage.kf.setImage(with: URL(string : homeData?.data[indexPath.item].thumbnail ?? "")!)
        cell.buttonImage.layer.cornerRadius = 8
        
        cell.HomeImageButton.addTarget(self, action: #selector(cellaction(_:)), for: .touchUpInside)
        
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

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200.0 // 예시로 높이를 100으로 고정하였습니다.
    }
}

extension UILabel {
    func setBottomLine(borderColor: UIColor, hight : Double, bottom : CGFloat) {
          self.backgroundColor = UIColor.clear
          let borderLine = UIView()
          borderLine.frame = CGRect(x: 0, y: Double(self.frame.height + bottom), width: Double(self.frame.width), height: hight)
          borderLine.backgroundColor = borderColor
          self.addSubview(borderLine)
     }
}
