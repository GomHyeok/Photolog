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
        
        // KeywordSearch 설정
        let KeywordSearchColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let keywordSearchFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let keywordSearchAttributes: [NSAttributedString.Key: Any] = [
            .font: keywordSearchFont,
            .foregroundColor: KeywordSearchColor,
            .kern: 1.2
        ]
        KeywordSearch.attributedText = NSMutableAttributedString(string: KeywordSearch.text ?? "", attributes: keywordSearchAttributes)

        // SortRecent 설정
        let sortRecentColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let sortRecentFont = UIFont(name: "Pretendard-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let sortRecentAttributes: [NSAttributedString.Key: Any] = [
            .font: sortRecentFont,
            .foregroundColor: sortRecentColor, // 이 부분을 수정했습니다.
            .kern: 1.2
        ]
        SortRecent.setAttributedTitle(NSMutableAttributedString(string: SortRecent.titleLabel?.text ?? "", attributes: sortRecentAttributes), for: .normal)

        // SortLike 설정
        let sortLikeColor =  UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let sortLikeFont = UIFont(name: "Pretendard-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let sortLikeAttributes: [NSAttributedString.Key: Any] = [
            .font: sortLikeFont,
            .foregroundColor: sortLikeColor, // 이 부분을 수정했습니다.
            .kern: 1.2
        ]
        SortLike.setAttributedTitle(NSMutableAttributedString(string: SortLike.titleLabel?.text ?? "", attributes: sortLikeAttributes), for: .normal)

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
            
        // 이미지 설정
        cell.BoardImage.kf.setImage(with: URL(string : settingData?.data?[indexPath.row].thumbnail ?? ""))
            
        // Title 설정
        let titleText = self.settingData?.data?[indexPath.row].title ?? "제목이 없습니다."
        let titleFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let titleColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor,
            .kern: 1.2
        ]
        cell.Title.attributedText = NSMutableAttributedString(string: titleText, attributes: titleAttributes)

        // City 설정
        let cityText = self.settingData?.data?[indexPath.row].city ?? "도시를 알 수 없습니다."
        let cityFont = UIFont(name: "Pretendard-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let cityColor = UIColor(red: 0.651, green: 0.651, blue: 0.651, alpha: 1)
        let cityAttributes: [NSAttributedString.Key: Any] = [
            .font: cityFont,
            .foregroundColor: cityColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .kern: -0.16
        ]
        cell.City.attributedText = NSMutableAttributedString(string: cityText, attributes: cityAttributes)

        // HartNum 설정
        let hartNumText = String(self.settingData?.data?[indexPath.row].likes ?? 0)
        let hartNumColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let hartNumFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let hartNumAttributes: [NSAttributedString.Key: Any] = [
            .font: hartNumFont,
            .foregroundColor: hartNumColor,
            .kern: -0.26
        ]
        cell.HartNum.attributedText = NSMutableAttributedString(string: hartNumText, attributes: hartNumAttributes)

        // Creator 설정
        let creatorText = "By. " + (self.settingData?.data?[indexPath.row].nickname ?? "")
        let creatorFont = UIFont(name: "Pretendard-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let creatorColor = UIColor(red: 0.455, green: 0.455, blue: 0.479, alpha: 1)
        let creatorAttributes: [NSAttributedString.Key: Any] = [
            .font: creatorFont,
            .foregroundColor: creatorColor,
            .kern: -0.2
        ]
        cell.Creator.attributedText = NSMutableAttributedString(string: creatorText, attributes: creatorAttributes)
        cell.Creator.textAlignment = .right

        
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
        
        return CGSize(width: widthPerItem, height: 324)  // 높이를 두 배로 늘림
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
