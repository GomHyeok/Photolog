//
//  TagCollectionViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class TagCollectionViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var kind : Bool = false
    var articleData : [Content] = []
    var tourData : [contentData]=[]
    var tag : String = ""
    var currentPage : Int = 0
    var isLoading : Bool = false

    @IBOutlet weak var TagCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TagCollection.delegate = self
        TagCollection.dataSource = self
        
        loadMoreData(page: currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height
       if offsetY > contentHeight - scrollView.frame.height {
           loadMoreData(page: currentPage)
       }
   }
    
    func loadMoreData(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        if kind {
            Tour {
                self.TagCollection.reloadData()
                self.currentPage += 1
                self.isLoading = false
            }
        }
        else {
            photo {
                self.TagCollection.reloadData()
                self.currentPage += 1
                self.isLoading = false
            }
        }
    }

}

extension TagCollectionViewController : UICollectionViewDelegate {
    
}

extension TagCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if kind {
            return tourData.count
        }
        else {
            return articleData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        if kind {
            if self.tourData[indexPath.row].firstimage != "" {
                cell.TagImage.kf.setImage(with: URL(string: self.tourData[indexPath.row].firstimage), completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                })
            }
            else {
                cell.TagImage.image = UIImage(named: "blackHart")
            }
            cell.TagButton.tag = tourData[indexPath.row].contentId
            cell.TagButton.addTarget(self, action: #selector(tourButton), for: .touchUpInside)
        }
        else {
            if self.articleData[indexPath.row].photoUrl != "" {
                cell.TagImage.kf.setImage(with: URL(string: self.articleData[indexPath.row].photoUrl), completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                })
                cell.TagButton.tag = articleData[indexPath.row].photoId
                cell.TagButton.addTarget(self, action: #selector(articleButton), for: .touchUpInside)
            }
        }
        
        return cell
    }
    
    @objc func articleButton (_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        if let boardView = storyboard.instantiateViewController(withIdentifier: "ArticleTagViewController") as? ArticleTagViewController {
            
            boardView.token = self.token
            boardView.id = self.id
            boardView.ArticleId = sender.tag
            
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else {print("board 문제")}
    }
    
    @objc func tourButton (_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        if let boardView = storyboard.instantiateViewController(withIdentifier: "TagViewController") as? TagViewController {
            
            boardView.token = self.token
            boardView.id = self.id
            boardView.contentId = sender.tag
            
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else {print("board 문제")}
        
    }
}

extension TagCollectionViewController : UICollectionViewDelegateFlowLayout {
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

extension TagCollectionViewController {
    func Tour(completion: @escaping () -> Void) {
        UserService.shared.Tour(token: token, page: currentPage, tag: tag) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? TourResponse else {return}
                        self.tourData.append(contentsOf: data.data?.content ?? [])
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
    
    func photo(completion: @escaping () -> Void) {
        UserService.shared.PhotoTag(token: token, tag: tag, page: currentPage){
                response in
            switch response {
                case .success(let data) :
                guard let data = data as? PhotoResponse else {return}
                self.articleData.append(contentsOf: data.data.content)
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
