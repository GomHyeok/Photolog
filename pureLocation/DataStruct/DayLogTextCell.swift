//
//  DayLogTextCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import Foundation
import UIKit

class DayLogTextCell : UITableViewCell {
    var data : [URL] = []
    var token : String = ""
    var locationId : Int = 0
    var st : String = ""

    
    @IBOutlet weak var AIButton: UIButton!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var LocationName: UITextField!
    @IBOutlet weak var BackGroundImage: UIImageView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var DayLogCollection: UICollectionView!
    @IBOutlet weak var ping: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Delegate와 DataSource를 설정
        self.DayLogCollection.delegate = self
        self.DayLogCollection.dataSource = self
        
        self.AIButton.addTarget(self, action: #selector(buttontouch), for: .touchUpInside)
        
        if let layout = DayLogCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: DayLogCollection.bounds.width / 2, height: DayLogCollection.bounds.height)
        }
    }
    
    func setData(_ newData: [URL]) {
        self.data = newData
        DispatchQueue.main.async {
            self.DayLogCollection.reloadData()
        }
    }
    
    @objc func buttontouch (_ sender : UIButton) {
        print(token)
        var keyword : [String] = []
        keyword = self.Description.text.split(separator: ",").map(String.init)
        Review(locationId: self.locationId, keyword: keyword) {
            self.Description.text! = self.st
        }
    }
}

extension DayLogTextCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // return the size of item
            return CGSize(width:148, height: 148)
        }
}

extension DayLogTextCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: DayTagCell.self)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DayTagCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        guard let location = cell.location else {
            return cell
        }
        location.kf.setImage(with: data[indexPath.item])
        return cell
    }
}

extension DayLogTextCell {
    func Review (locationId : Int, keyword : [String], completion : @escaping () -> Void) {
        UserService.shared.Review(token: token, locationId: locationId, keyword: keyword) {
                response in
            switch response {
                case .success(let data) :
                    guard let data = data as? staticResponse else {return}
                    self.st = data.data!
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


