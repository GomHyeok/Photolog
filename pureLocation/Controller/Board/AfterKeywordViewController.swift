//
//  AfterKeywordViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/01.
//

import UIKit

class AfterKeywordViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var settingData : ArticlesFilteringResponse?
    var filters : [String : String] = [:]
    var themas : [String] = []
    
    
    @IBOutlet weak var bottomNavigation: UIView!
    @IBOutlet weak var ResultTable: UITableView!
    @IBOutlet weak var Like: UIButton!
    @IBOutlet weak var Recent: UIButton!
    @IBOutlet weak var Result: UILabel!
    
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
        
        self.navigationController?.isNavigationBarHidden = false
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        
        
        Result.font = UIFont(name: "Pretendard-Bold", size: 20)
        Recent.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        Like.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        ResultTable.delegate = self
        ResultTable.dataSource = self
        
        
        ArticleFiltering {
            self.ResultTable.reloadData()
        }
    }
    
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LikeButton(_ sender: UIButton) {
        filters["sort"] = nil
        ArticleFiltering {
            self.ResultTable.reloadData()
        }
    }
    
    @IBAction func RecentButton(_ sender: UIButton) {
        if filters["sort"] == nil {
            filters["sort"] = "recent"
        }
        ArticleFiltering {
            self.ResultTable.reloadData()
        }
    }
    
    
    @IBOutlet weak var HomeButton: UIView!
    
    
    @IBAction func Homebutton(_ sender: UIButton) {
        delegate?.switchToHome()
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
}

extension AfterKeywordViewController {
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

extension AfterKeywordViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
}

extension AfterKeywordViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterKeyword", for: indexPath) as! AfterKeyword
        
        cell.TableImage.kf.setImage(with: URL(string : settingData?.data?[indexPath.row].thumbnail ?? ""))
        cell.TableImage.layer.cornerRadius = 5
        
        let titleFont = UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1),
            .kern: 0.8
        ]
        let titleText = self.settingData?.data?[indexPath.row].title ?? "제목이 없습니다."
        cell.Title.attributedText = NSMutableAttributedString(string: titleText, attributes: titleAttributes)

        let cityFont = UIFont(name: "Pretendard-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let cityAttributes: [NSAttributedString.Key: Any] = [
            .font: cityFont,
            .foregroundColor: UIColor(red: 0.455, green: 0.455, blue: 0.479, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let cityText = self.settingData?.data?[indexPath.row].city ?? "도시를 알 수 없습니다."
        cell.City.attributedText = NSMutableAttributedString(string: cityText, attributes: cityAttributes)

        let hartNumFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let hartNumAttributes: [NSAttributedString.Key: Any] = [
            .font: hartNumFont,
            .foregroundColor: UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        ]
        let hartNumText = String(self.settingData?.data?[indexPath.row].likes ?? 0)
        cell.HartNum.attributedText = NSMutableAttributedString(string: hartNumText, attributes: hartNumAttributes)

        let daysFont = UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let daysAttributes: [NSAttributedString.Key: Any] = [
            .font: daysFont,
            .foregroundColor: UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        ]
        let daysText = "\(self.settingData?.data?[indexPath.row].startDate ?? "") ~ \(self.settingData?.data?[indexPath.row].endDate ?? "")"
        cell.Days.attributedText = NSMutableAttributedString(string: daysText, attributes: daysAttributes)

        cell.PhotoBackGround.layer.cornerRadius = 57

        let photoNumFont = UIFont(name: "Pretendard-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        let photoNumAttributes: [NSAttributedString.Key: Any] = [
            .font: photoNumFont,
            .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            .kern: 0.5
        ]
        let photoNumText = String(self.settingData?.data?[indexPath.row].photoCnt ?? 0)
        cell.PhotoNum.attributedText = NSMutableAttributedString(string: photoNumText, attributes: photoNumAttributes)
        cell.PhotoNum.textAlignment = .center

        let bookNumFont = UIFont(name: "Pretendard-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13)
        let bookNumAttributes: [NSAttributedString.Key: Any] = [
            .font: bookNumFont,
            .foregroundColor: UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        ]
        let bookNumText = String(self.settingData?.data?[indexPath.row].bookmarks ?? 0)
        cell.BookNum.attributedText = NSMutableAttributedString(string: bookNumText, attributes: bookNumAttributes)

        
        return cell
    }
}
