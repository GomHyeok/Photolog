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


