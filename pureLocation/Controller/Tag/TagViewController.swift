//
//  TagViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class TagViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var contentId : Int = 0
    var settingData : TourInfoResponse!
    var bookmarkStatus : Bool = false
    
    @IBOutlet weak var TableViewin: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = ""
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        TableViewin.delegate = self
        TableViewin.dataSource = self
        
        tourContent {
            self.TableViewin.reloadData()
        }
        
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Home(_ sender: UIButton) {
        delegate?.switchToHome()
    }
    
    
    @IBAction func My(_ sender: Any) {
        delegate?.switchToMypage()
    }
    
    @IBAction func Tag(_ sender: UIButton) {
        delegate?.switchToTag()
    }
    
    @IBAction func Board(_ sender: Any) {
        delegate?.switchToBoard()
    }
    
}

extension TagViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 615
        }
        else {
            return 415
        }
        
    }
}

extension TagViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagViewCell", for: indexPath) as! TagViewCell
            if settingData?.data != nil{
                cell.CellImage.kf.setImage(with: URL(string: self.settingData?.data?.imageUrl ?? "")!)
                cell.CellTitle.text = self.settingData?.data?.title ?? ""
                cell.CellContent.text = self.settingData?.data?.content ?? ""
                cell.Category.text = self.settingData.data?.cat1 ?? ""
                cell.Category.text! += ">"
                cell.Category.text! += self.settingData.data?.cat2 ?? ""
                cell.Category.text! += ">"
                cell.Category.text! += self.settingData.data?.cat3 ?? ""
                
            }
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as! otherCell
            
                let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
                
                initialViewController.token = self.token
                initialViewController.id = self.id
                initialViewController.kind = true
                
                self.addChild(initialViewController)
                initialViewController.view.frame = cell.ContainerView.bounds
                cell.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
            
            return cell
        }
    }
    
//    @objc func bookmarks(_ sender : UIButton) {
//        if bookmarkStatus {
//            tourCancle(tourId: contentId){
//                
//            }
//            bookmarkStatus = false
//            sender.setImage(UIImage(named: "bookmark"), for: .normal)
//
//        }
//        else {
//            tourBookMark {
//                <#code#>
//            }
//            bookmarkStatus = true
//            sender.setImage(UIImage(named: "blackBook"), for: .normal)
//        }
//    }
    
    
}

extension TagViewController {
    func tourContent(completion : @escaping () -> Void) {
        UserService.shared.TourInfo(token: token, contentId: contentId) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? TourInfoResponse else {return}
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
    
    func tourCancle(tourId : Int, completion : @escaping () ->Void) {
        UserService.shared.TourBookMarkCancle(token: token, tourId: tourId) {
            response in
            switch response {
                case .success(let data) :
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    completion()
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