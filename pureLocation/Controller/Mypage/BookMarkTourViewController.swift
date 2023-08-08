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
    var tourId : [Int : Int] = [:]

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
    
}

extension BookMarkTourViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageTour", for: indexPath) as! MyPageTour
        
        cell.TourImage.kf.setImage(with: URL(string: self.data?.data?[indexPath.row].firstImage ?? "")!)
        //self.tourId[self.data?.data?[indexPath.row].contentId ?? 0] = self.data?.data?[indexPath.row].tourId ?? 0
        
        //cell.TourButton.tag = self.data?.data?[indexPath.row].contentId ?? 0
        cell.TourButton.addTarget(self, action: #selector(tourButton), for: .touchUpInside)
        
        return cell
    }
    
    @objc func tourButton (_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        if let boardView = storyboard.instantiateViewController(withIdentifier: "TagViewController") as? TagViewController {
            
            boardView.token = self.token
            boardView.id = self.id
            boardView.contentId = sender.tag
            boardView.tourId = self.tourId[sender.tag] ?? 0
            
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else {print("board 문제")}
    }
}

extension BookMarkTourViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = (itemsPerRow - 1) * 2
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
