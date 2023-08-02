import Foundation
import UIKit

class LocationInfoCell : UITableViewCell {
    var data : [URL] = []
    
    @IBOutlet weak var Descriptions: UITextView!
    @IBOutlet weak var LineImage: UIImageView!
    @IBOutlet weak var PingImage: UIImageView!
    @IBOutlet weak var LocationTitle: UILabel!
    @IBOutlet weak var MapCollection: UICollectionView!
    @IBOutlet weak var FullAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Delegate와 DataSource를 설정
        self.MapCollection.delegate = self
        self.MapCollection.dataSource = self
        
        if let layout = MapCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func setData(_ newData: [URL]) {
        self.data = newData
        DispatchQueue.main.async {
            self.MapCollection.reloadData()
        }
    }
}


extension LocationInfoCell : UICollectionViewDelegate {
    
    
}

extension LocationInfoCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: MapCollectionCell.self)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MapCollectionCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        guard let location = cell.locations else {
            return cell
        }
        location.kf.setImage(with: data[indexPath.item])
        return cell
    }
}

extension LocationInfoCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // return the size of item
            return CGSize(width: 148, height: collectionView.frame.height)
    }
}
