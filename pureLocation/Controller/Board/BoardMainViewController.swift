//
//  BoardMainViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/30.
//

import UIKit

class BoardMainViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var settingData : ArticlesFilteringResponse?
    var filters : [String : String] = [:]
    var themas : [String] = []
    var budget : Int = 0
    var day : Int = 0
    
    
    
    @IBOutlet weak var KeywordSearch: UITextField!
    @IBOutlet weak var BoardCollection: UICollectionView!
    @IBOutlet weak var SortRecent: UIButton!
    @IBOutlet weak var SortLike: UIButton!
    @IBOutlet weak var bottomNavigation: UIView!
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            let border = CALayer()
            let width = CGFloat(0.5)
            border.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
            border.frame = CGRect(x: 0, y: 0, width:  self.bottomNavigation.frame.size.width, height: width)
            border.borderWidth = width
            self.bottomNavigation.layer.addSublayer(border)
            self.bottomNavigation.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        KeywordSearch.font = UIFont(name: "Pretendard-Regular", size: 14)
        SortRecent.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        SortLike.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        BoardCollection.collectionViewLayout = layout
        
        BoardCollection.delegate = self
        BoardCollection.dataSource = self
        
        ArticleFiltering {
            self.BoardCollection.reloadData()
        }
    }

    @IBAction func HomeButton(_ sender: UIButton) {
        delegate?.switchToHome()
    }
    
    @IBAction func RecentButton(_ sender: UIButton) {
        if filters["sort"] == nil {
            filters["sort"] = "recent"
        }
        ArticleFiltering {
            self.BoardCollection.reloadData()
        }
    }
    
    
    @IBAction func MyPageButton(_ sender: UIButton) {
        delegate?.switchToMypage()
    }
    
    
    @IBAction func Tag(_ sender: UIButton) {
        delegate?.switchToTag()
    }
    
    
    @IBAction func Map(_ sender: UIButton) {
        delegate?.switchToMap()
    }
    
    @IBAction func GradeButton(_ sender: UIButton) {
        filters["sort"] = nil
        ArticleFiltering {
            self.BoardCollection.reloadData()
        }
    }
    
    @IBAction func KeywordButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let
            Keyword = storyboard.instantiateViewController(withIdentifier: "KeywordViewController") as? KeywordViewController {
            
            Keyword.token = self.token
            Keyword.id = self.id
            
            self.navigationController?.pushViewController(Keyword, animated: true)
        }
        else {print("Keyword 문제")}
    }
}

extension BoardMainViewController {
    func ArticleFiltering(completion: @escaping () -> Void) {
        UserService.shared.ArticleFiltering(token: token, Filters: filters, thema: themas) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? ArticlesFilteringResponse else {return}
                        self.settingData = data
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

extension BoardMainViewController : UICollectionViewDelegate {
    
}

extension BoardMainViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBoardCell", for: indexPath) as! MainBoardCell
        
        cell.BoardImage.kf.setImage(with: URL(string : settingData?.data?[indexPath.row].thumbnail ?? ""))
        cell.Title.text = self.settingData?.data?[indexPath.row].title ?? "제목이 없습니다."
        cell.Title.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        cell.City.text = self.settingData?.data?[indexPath.row].city ?? "도시를 알 수 없습니다."
        cell.City.font = UIFont(name: "Pretendard-Regular", size: 8)
        cell.City.setBottomLine(borderColor: UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0), hight: 0.5, bottom: 0)
        
        cell.HartNum.text = String(self.settingData?.data?[indexPath.row].likes ?? 0)
        
        cell.Creator.text = "by."
        cell.Creator.text! += self.settingData?.data?[indexPath.row].nickname ?? ""
        cell.Creator.font = UIFont(name: "Pretendard-Regular", size: 10)
        
        cell.BoardButton.tag = self.settingData?.data?[indexPath.row].id ?? 0
        cell.BoardButton.addTarget(self, action: #selector(ButtonAction(_:)),for: .touchUpInside)
        
        return cell
    }
    
    @objc func ButtonAction(_ sender : UIButton) {
        print("button")
        if let
            Keyword = storyboard?.instantiateViewController(withIdentifier: "BoardViewController") as? BoardViewController {
            
            Keyword.token = self.token
            Keyword.id = self.id
            Keyword.ArticleId = sender.tag
            
            self.navigationController?.pushViewController(Keyword, animated: true)
        }
        else {print("Keyword 문제")}
    }
}

extension BoardMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = 2 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.6)  // 높이를 두 배로 늘림
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0) // 좌우 여백을 0으로 수정
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       let itemsPerRow: CGFloat = 2
       let paddingSpace = 2 * (itemsPerRow - 1)
       return paddingSpace / (itemsPerRow - 1) // 여백을 2로 설정
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       let itemsPerRow: CGFloat = 2
       let paddingSpace = 2 * (itemsPerRow - 1)
       return paddingSpace / (itemsPerRow - 1) // 여백을 2로 설정
   }
}
