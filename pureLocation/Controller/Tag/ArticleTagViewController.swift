//
//  ArticleTagViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class ArticleTagViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var ArticleId : Int = 0
    var settingData : ArticleInfoResponse?
    var bookmarkStatus = false
    var articleData : ArticlesFilteringResponse!

    @IBOutlet weak var TableViewin: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let button = UIButton(type: .system)
        if let menuImage = UIImage(named: "report1")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(menuImage, for: .normal)
            button.showsMenuAsPrimaryAction = true
            button.menu = createMenu()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        TableViewin.delegate = self
        TableViewin.dataSource = self
        
        articleInfo() {
            self.TableViewin.reloadData()
        }
        
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func home(_ sender: UIButton) {
        delegate?.switchToHome()
    }
    
    
    @IBAction func Board(_ sender: UIButton) {
        delegate?.switchToBoard()
    }
    
    
    @IBAction func Ta(_ sender: Any) {
        delegate?.switchToTag()
    }
    
    @IBAction func MyPage(_ sender: UIButton) {
        delegate?.switchToMypage()
    }
    
    func createMenu() -> UIMenu {
        let action1 = UIAction(title: "신고하기", image: UIImage(named: "report")) { action in
            self.check(message: "게시물을 신고하시겠습니까?")
        }

        let menu = UIMenu(title: "", children: [action1])
        return menu
    }
}

extension ArticleTagViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 615
        }
        else {
            return 415
        }
        
    }
}

extension ArticleTagViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTagCell", for: indexPath) as! ArticleTagCell
            if settingData?.data?.days?.count ?? 0 > 0 {
                cell.CellImage.kf.setImage(with: URL(string: self.settingData?.data?.days?[0].locations?[0].photoUrls[0] ?? "")!)
                cell.CellTitle.text = self.settingData?.data?.title ?? ""
                cell.CellContent.text = self.settingData?.data?.summary ?? ""
            }
            if bookmarkStatus {
                cell.BookMark.setImage(UIImage(named: "blackBook"), for: .normal)
            }
            else {
                cell.BookMark.setImage(UIImage(named: "bookmark"), for: .normal)
            }
            cell.BookMark.addTarget(self, action: #selector(bookmarks), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as! otherCell
            
            ArticleFiltering {
                let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
                
                initialViewController.token = self.token
                initialViewController.id = self.id
                initialViewController.articleData = self.articleData
                initialViewController.kind = false
                
                self.addChild(initialViewController)
                initialViewController.view.frame = cell.ContainerView.bounds
                cell.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
            }
            
            return cell
        }
    }
    
    @objc func bookmarks(_ sender : UIButton) {
        if bookmarkStatus {
            bookmarkCancle()
            bookmarkStatus = false
            sender.setImage(UIImage(named: "bookmark"), for: .normal)
            
            self.settingData?.data?.bookmarks -= 1
        }
        else {
            bookmark()
            bookmarkStatus = true
            sender.setImage(UIImage(named: "blackBook"), for: .normal)
        }
    }
}

extension ArticleTagViewController {
    func articleInfo (completion: @escaping () -> Void) {
        UserService.shared.ArticleInfo(token: token, articleId: ArticleId) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? ArticleInfoResponse else {return}
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
    
    func articleReport (completion : @escaping () -> Void) {
        UserService.shared.ArticleReport(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 신고할 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func check(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "신고", style: .default) {_ in
            self.articleReport {
                self.alert(message: "게시물을 신고하였습니다.")
            }
        }
        
        let cancle = UIAlertAction(title: "취소", style: .default)
        alertVC.addAction(okAction)
        alertVC.addAction(cancle)
        present(alertVC, animated: true)
    }
    
    func bookmark() {
        UserService.shared.bookmark(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글이 북마크 되었습니다.")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 신고할 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func bookmarkCancle() {
        UserService.shared.bookmarkCancle(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    self.alert(message: "게시글이 북마크 해제되었습니다.")
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    self.alert(message: "내가 쓴 글에는 신고할 수 없어요")
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
    
    func ArticleFiltering(completion: @escaping () -> Void) {
        UserService.shared.ArticleFiltering(token: token, Filters: [:], thema: []) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? ArticlesFilteringResponse else {return}
                        self.articleData = data
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
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
