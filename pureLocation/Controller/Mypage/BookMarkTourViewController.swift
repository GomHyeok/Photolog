//
//  BookMarkTourViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/04.
//

import UIKit

class BookMarkTourViewController: UIViewController {
    
    var data : TourBookMarkResponse?
    var token : String = ""
    var id : Int = 0

    @IBOutlet weak var TourCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        TourCollection.collectionViewLayout = layout

        TourCollection.delegate = self
        TourCollection.dataSource = self
    }
    
}

extension BookMarkTourViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }
}

extension BookMarkTourViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageTour", for: indexPath) as! MyPageTour
        
        cell.TourImage.kf.setImage(with: URL(string: self.data?.data?[indexPath.row].firstImage ?? "")!)
        
        return cell
    }
}
