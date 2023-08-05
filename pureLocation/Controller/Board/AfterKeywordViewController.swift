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
        return 150.0
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
        cell.Title.text = self.settingData?.data?[indexPath.row].title ?? "제목이 없습니다."
        cell.Title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        cell.City.text = self.settingData?.data?[indexPath.row].city ?? "도시를 알 수 없습니다."
        cell.City.font = UIFont(name: "Pretendard_Regular", size: 10)
        cell.sizeToFit()
        let underline = UIView()
        underline.backgroundColor = cell.City.textColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        cell.City.addSubview(underline)
        underline.bottomAnchor.constraint(equalTo: cell.City.bottomAnchor).isActive = true
        underline.leftAnchor.constraint(equalTo: cell.City.leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: cell.City.rightAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true // 밑줄의 높이를 지정합니다.
        
        cell.HartNum.text = String(self.settingData?.data?[indexPath.row].likes ?? 0)
        cell.HartNum.font = UIFont(name: "Pretendard-Regular", size: 13)
        cell.Days.text = self.settingData?.data?[indexPath.row].startDate
        cell.Days.text! += " ~ "
        cell.Days.text! += self.settingData?.data?[indexPath.row].endDate ?? ""
        cell.PhotoNum.text = String(self.settingData?.data?[indexPath.row].photoCnt ?? 0)
        cell.PhotoBackGround.layer.cornerRadius = 57
        
        cell.PhotoNum.font = UIFont(name: "Pretendard-Regular", size: 10)
        
        cell.BookNum.text = String(self.settingData?.data?[indexPath.row].bookmarks ?? 0)
        cell.BookNum.font = UIFont(name: "Pretendard-Regular", size: 13)
        
        return cell
    }
}
