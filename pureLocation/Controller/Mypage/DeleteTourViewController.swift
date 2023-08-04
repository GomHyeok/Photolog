//
//  DeleteTourViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/04.
//

import UIKit

class DeleteTourViewController: UIViewController {
    
    var data : TourBookMarkResponse?

    @IBOutlet weak var TourCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        TourCollection.collectionViewLayout = layout

        TourCollection.delegate = self
        TourCollection.dataSource = self
    }
    
    func getArticleID () -> [Int] {
        var tourId : [Int] = []
        
        for i in 0..<(data?.data?.count ?? 0) {
            let indexPath = IndexPath(row : i, section : 0)
            let cell = TourCollection.cellForItem(at: indexPath) as! TourDelete
            if cell.DeleteButton.tag % 2 == 1 {
                tourId.append(cell.tourID)
            }
        }
        
        return tourId
    }
    
}

extension DeleteTourViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }
}

extension DeleteTourViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TourDelete", for: indexPath) as! TourDelete
        
        cell.TourImage.kf.setImage(with: URL(string: self.data?.data?[indexPath.row].firstImage ?? "")!)
        cell.DeleteButton.tag = 0
        cell.DeleteButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        return cell
    }
    
    @objc func buttonTap (_ sender : UIButton) {
        sender.tag += 1
    }
}
