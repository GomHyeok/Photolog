//
//  HomeParentViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit

class HomeParentViewController: UIViewController, homeDelegate {
    var firstChild : HomeViewController!
    var secondChild : HomeNameViewController!
    var boardChild : BoardMainViewController!
    var keywordChild : AfterKeywordViewController!
    var myPageChild : MyPageMainViewController!
    var tagChild : TagMainViewController!
    
    var homeData : TravelAPIResponse?
    var token : String = ""
    var id : Int = 0
    var currentViewController : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 뷰 버튼 수정
        self.navigationController?.isNavigationBarHidden = true
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        firstChild = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        secondChild = storyboard.instantiateViewController(withIdentifier: "HomeNameViewController") as? HomeNameViewController
        
        let board = UIStoryboard(name: "Board", bundle: nil)
        boardChild = board.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController
        
        let keyword = UIStoryboard(name: "Board", bundle: nil)
        keywordChild = keyword.instantiateViewController(withIdentifier: "AfterKeywordViewController") as? AfterKeywordViewController
        
        let mypage = UIStoryboard(name: "MyPage", bundle: nil)
        myPageChild = mypage.instantiateViewController(withIdentifier: "MyPageMainViewController") as? MyPageMainViewController
        
        let tagpage = UIStoryboard(name: "TagPage", bundle: nil)
        tagChild = tagpage.instantiateViewController(withIdentifier: "TagMainViewController") as? TagMainViewController
        
        // delegate 설정
        firstChild.delegate = self
        secondChild.delegate = self
        boardChild.delegate = self
        myPageChild.delegate = self
        tagChild.delegate = self
        
        firstChild.token = self.token
        firstChild.id = self.id
        
        currentViewController = firstChild
        
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    func switchTotaltToMap(data : TravelAPIResponse?) {
        firstChild.willMove(toParent: nil)
        firstChild.view.removeFromSuperview()
        firstChild.removeFromParent()
        
        secondChild.token = self.token
        secondChild.id = self.id
        secondChild.homeData = data
        
        currentViewController = secondChild
        
        // 두 번째 자식 뷰 컨트롤러를 추가합니다.
        addChild(secondChild)
        view.addSubview(secondChild.view)
        secondChild.didMove(toParent: self)
    }
    
    func switchMaptoTotal() {
        secondChild.willMove(toParent: nil)
        secondChild.view.removeFromSuperview()
        secondChild.removeFromParent()
        
        firstChild.token = self.token
        firstChild.id = self.id
        
        currentViewController = firstChild
        
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    func switchToBoard() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        boardChild.token = self.token
        boardChild.id = self.id
        
        currentViewController = boardChild
        
        addChild(boardChild)
        view.addSubview(boardChild.view)
        boardChild.didMove(toParent: self)
    }
    
    func switchToHome() {
        print("home")
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
            
        firstChild.token = self.token
        firstChild.id = self.id
        firstChild.viewDidLoad()
        
        currentViewController = firstChild
        
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    func switchToMypage() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        myPageChild.token = self.token
        myPageChild.id = self.id
        
        currentViewController = myPageChild
        
        addChild(myPageChild)
        view.addSubview(myPageChild.view)
        myPageChild.didMove(toParent: self)
    }
    
    func switchToTag() {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        
        tagChild.token = self.token
        tagChild.id = self.id
        
        currentViewController = tagChild
        
        addChild(tagChild)
        view.addSubview(tagChild.view)
        tagChild.didMove(toParent: self)
    }
    
}
