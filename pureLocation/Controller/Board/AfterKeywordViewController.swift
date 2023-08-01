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
    
    
    @IBOutlet weak var ResultTable: UITableView!
    @IBOutlet weak var Like: UIButton!
    @IBOutlet weak var Recent: UIButton!
    @IBOutlet weak var Result: UILabel!
    
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
        delegate?.switchToHome(pos: 21)
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
        return 200.0
    }
}

extension AfterKeywordViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterKeyword", for: indexPath) as! AfterKeyword
        
        cell.TableImage.kf.setImage(with: URL(string : settingData?.data?[indexPath.row].thumbnail ?? ""))
        cell.Title.text = self.settingData?.data?[indexPath.row].title ?? "제목이 없습니다."
        cell.Title.font = UIFont(name: "Pretendard-Bold", size: 16)
        cell.City.text = self.settingData?.data?[indexPath.row].city ?? "도시를 알 수 없습니다."
        cell.City.font = UIFont(name: "Pretendard_Regular", size: 10)
        cell.HartNum.text = String(self.settingData?.data?[indexPath.row].likes ?? 0)
        cell.Days.text = self.settingData?.data?[indexPath.row].startDate
        cell.Days.text! += " ~ "
        cell.Days.text! += self.settingData?.data?[indexPath.row].endDate ?? ""
        
        return cell
    }
}
