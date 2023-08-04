import UIKit

class MyPageMainViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    var articleData : BookMarkedArticleResponse?
    var currentVC : UIViewController!
    var now : Int = 0
    var articleId : [Int] = []
    var tourId : [Int] = []
    var userData : UserInfoResponse?
    var tourData : TourBookMarkResponse?
    
    @IBOutlet weak var BookMarkLabel: UILabel!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var BottomNavigation: UIView!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var Board: UIButton!
    @IBOutlet weak var Tour: UIButton!
    @IBOutlet weak var UserId: UILabel!
    @IBOutlet weak var NickName: UILabel!
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            let upper = CALayer()// 선의 두께
            upper.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor // 선의 색상
            upper.frame = CGRect(x: 0, y: 0, width:  self.BottomNavigation.frame.size.width, height: CGFloat(0.5))
            upper.borderWidth = CGFloat(0.5)
            self.BottomNavigation.layer.addSublayer(upper)
            self.BottomNavigation.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfo {
            self.UserId.text = self.userData?.data?.email ?? ""
            self.NickName.text = self.userData?.data?.nickName ?? ""
        }
        
        BookMarked {
            if(self.articleData?.data?.count == 0) {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoBookMarkBoardViewController") as! NoBookMarkBoardViewController
                
                initialViewController.token = self.token
                initialViewController.id = self.id
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 0
            }
            else {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "BookMarkBoardViewController") as! BookMarkBoardViewController
                
                initialViewController.data = self.articleData
                initialViewController.token = self.token
                initialViewController.id = self.id
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 1
            }
        }
        Board.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        UserId.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        NickName.font = UIFont(name: "Pretendard-Medium", size: 14)
        BookMarkLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    
    @IBAction func BoardPageButton(_ sender: UIButton) {
        print("board")
        self.delegate?.switchToBoard()
    }
    
    @IBAction func HomeButton(_ sender: UIButton) {
        self.delegate?.switchToHome()
    }
    
    @IBAction func TourButton(_ sender: UIButton) {
        self.Board.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
        self.Tour.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        
        tourBookMark {
            if self.tourData?.data?.count == 0 {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoTourViewController") as! NoTourViewController
                
                initialViewController.token = self.token
                initialViewController.id = self.id
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 3
            }
            else {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "BookMarkTourViewController") as! BookMarkTourViewController
                
                initialViewController.data = self.tourData
                initialViewController.token = self.token
                initialViewController.id = self.id
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 3
            }
        }
    }
    
    
    @IBAction func BoardButton(_ sender: UIButton) {
        self.Board.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        self.Tour.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
        
        BookMarked {
            if(self.articleData?.data?.count == 0) {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoBookMarkBoardViewController") as! NoBookMarkBoardViewController
                
                self.currentVC?.willMove(toParent: nil)
                self.currentVC?.view.removeFromSuperview()
                self.currentVC?.removeFromParent()
                
                initialViewController.token = self.token
                initialViewController.id = self.id
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 0
            }
            else {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "BookMarkBoardViewController") as! BookMarkBoardViewController
                
                initialViewController.data = self.articleData
                
                self.currentVC?.willMove(toParent: nil)
                self.currentVC?.view.removeFromSuperview()
                self.currentVC?.removeFromParent()
                
                self.addChild(initialViewController)
                initialViewController.view.frame = self.ContainerView.bounds
                self.ContainerView.addSubview(initialViewController.view)
                initialViewController.didMove(toParent: self)
                
                self.currentVC = initialViewController
                self.now = 1
            }
        }
    }
    
    
    @IBAction func Edit(_ sender: UIButton) {
        if(self.now == 0 || self.now == 3) {
            self.alert(message: "편집할 내용이 없습니다.")
        }
        else if(self.now == 1) {
            self.now = 2
            EditButton.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1.0)
            EditButton.layer.cornerRadius = 16
            EditButton.titleLabel?.text! = "완료"
            EditButton.setTitleColor(UIColor.white, for: .normal)
            let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "DeleteBoardViewController") as! DeleteBoardViewController
            
            self.currentVC?.willMove(toParent: nil)
            self.currentVC?.view.removeFromSuperview()
            self.currentVC?.removeFromParent()
            
            initialViewController.data = self.articleData
            
            self.addChild(initialViewController)
            initialViewController.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(initialViewController.view)
            initialViewController.didMove(toParent: self)
            
            self.currentVC = initialViewController
        }
        else if (self.now == 2){
            let dispatchGroup = DispatchGroup()
            self.now = 1
            EditButton.backgroundColor = UIColor.white
            EditButton.titleLabel?.text! = "편집"
            EditButton.setTitleColor(UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0), for: .normal)
            
            self.articleId = (currentVC as! DeleteBoardViewController).getArticleID()
            for id in self.articleId {
                dispatchGroup.enter()
                bookmarkCancle(ArticleId: id) {
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main){
                self.alert(message: "북마크가 해제되었습니다.")
                self.BookMarked {
                    if(self.articleData?.data?.count == 0) {
                        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoBookMarkBoardViewController") as! NoBookMarkBoardViewController
                        
                        self.currentVC?.willMove(toParent: nil)
                        self.currentVC?.view.removeFromSuperview()
                        self.currentVC?.removeFromParent()
                        
                        initialViewController.token = self.token
                        initialViewController.id = self.id
                        
                        self.addChild(initialViewController)
                        initialViewController.view.frame = self.ContainerView.bounds
                        self.ContainerView.addSubview(initialViewController.view)
                        initialViewController.didMove(toParent: self)
                        
                        self.currentVC = initialViewController
                        self.now = 0
                    }
                    else {
                        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "BookMarkBoardViewController") as! BookMarkBoardViewController
                        
                        initialViewController.data = self.articleData
                        
                        self.currentVC?.willMove(toParent: nil)
                        self.currentVC?.view.removeFromSuperview()
                        self.currentVC?.removeFromParent()
                        
                        self.addChild(initialViewController)
                        initialViewController.view.frame = self.ContainerView.bounds
                        self.ContainerView.addSubview(initialViewController.view)
                        initialViewController.didMove(toParent: self)
                        
                        self.currentVC = initialViewController
                        self.now = 1
                    }
                }
            }
        }
        else if (self.now == 4) {
            self.now = 5
            EditButton.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1.0)
            EditButton.titleLabel?.text! = "완료"
            EditButton.setTitleColor(UIColor.white, for: .normal)
            let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "DeleteTourViewController") as! DeleteTourViewController
            
            initialViewController.data = self.tourData
            
            self.currentVC?.willMove(toParent: nil)
            self.currentVC?.view.removeFromSuperview()
            self.currentVC?.removeFromParent()
            
            self.addChild(initialViewController)
            initialViewController.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(initialViewController.view)
            initialViewController.didMove(toParent: self)
            
            self.currentVC = initialViewController
            self.now = 5
            
        }
        else if (self.now == 5){
            self.now = 4
            EditButton.backgroundColor = UIColor.white
            EditButton.titleLabel?.text! = "편집"
            EditButton.setTitleColor(UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0), for: .normal)
            
            let dispatchGroup = DispatchGroup()
            let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "DeleteTourViewController") as! DeleteTourViewController
            
            self.tourId = (currentVC as! DeleteTourViewController).getArticleID()
            
            for id in self.tourId {
                dispatchGroup.enter()
                tourCancle(tourId: id) {
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main){
                self.alert(message: "북마크가 해제되었습니다.")
                self.tourBookMark {
                    if(self.tourData?.data?.count == 0) {
                        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoTourViewController") as! NoTourViewController
                        
                        initialViewController.token = self.token
                        initialViewController.id = self.id
                        
                        self.currentVC?.willMove(toParent: nil)
                        self.currentVC?.view.removeFromSuperview()
                        self.currentVC?.removeFromParent()
                        
                        self.addChild(initialViewController)
                        initialViewController.view.frame = self.ContainerView.bounds
                        self.ContainerView.addSubview(initialViewController.view)
                        initialViewController.didMove(toParent: self)
                        
                        self.currentVC = initialViewController
                        self.now = 3
                    }
                    else {
                        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "BookMarkTourViewController") as! BookMarkTourViewController
                        
                        initialViewController.data = self.tourData
                        
                        self.currentVC?.willMove(toParent: nil)
                        self.currentVC?.view.removeFromSuperview()
                        self.currentVC?.removeFromParent()
                        
                        self.addChild(initialViewController)
                        initialViewController.view.frame = self.ContainerView.bounds
                        self.ContainerView.addSubview(initialViewController.view)
                        initialViewController.didMove(toParent: self)
                        
                        self.currentVC = initialViewController
                        self.now = 4
                    }
                }
            }
            
        }
    }
}

extension MyPageMainViewController {
    func BookMarked(completion : @escaping () -> Void) {
        UserService.shared.BookMarkedArticle(token: token) {
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? BookMarkedArticleResponse else {return}
                    print(data)
                    self.articleData = data
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
            completion()
        }
    }
    
    func bookmarkCancle(ArticleId : Int, completion : @escaping () -> Void) {
        UserService.shared.bookmarkCancle(token: token, articleId: ArticleId) {
            response in
            switch response {
                case .success(let data) :
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                    completion()
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
    
    func userInfo(completion : @escaping () -> Void) {
        UserService.shared.userInfo(id: id, token: token){
            response in
            switch response {
                case .success(let data) :
                    self.userData = data as? UserInfoResponse
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
    
    func tourBookMark(completion : @escaping () -> Void) {
        UserService.shared.TourBookMark(token: token){
            response in
            switch response {
                case .success(let data) :
                    print(data)
                    self.tourData = data as? TourBookMarkResponse
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
