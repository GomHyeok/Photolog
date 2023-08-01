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
    var homeData : TravelAPIResponse?
    var token : String = ""
    var id : Int = 0

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
        
        firstChild.token = self.token
        firstChild.id = self.id
        
        // delegate 설정
        firstChild.delegate = self
        secondChild.delegate = self
        boardChild.delegate = self
        // 첫 번째 자식 뷰 컨트롤러를 추가합니다.
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
        
        
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    func switchToBoard(pos : Int) {
        if pos  == 1 {
            firstChild.willMove(toParent: nil)
            firstChild.view.removeFromSuperview()
            firstChild.removeFromParent()
        }
        else if pos == 11 {
            secondChild.willMove(toParent: nil)
            secondChild.view.removeFromSuperview()
            secondChild.removeFromParent()
        }
        
        boardChild.token = self.token
        boardChild.id = self.id
        
        addChild(boardChild)
        view.addSubview(boardChild.view)
        boardChild.didMove(toParent: self)
    }
    
    func switchToHome(pos: Int) {
        if pos == 2 {
            boardChild.willMove(toParent: nil)
            boardChild.view.removeFromSuperview()
            boardChild.removeFromParent()
            
            firstChild.token = self.token
            firstChild.id = self.id
            
            
            addChild(firstChild)
            view.addSubview(firstChild.view)
            firstChild.didMove(toParent: self)
        }
        
        if pos == 21 {
            boardChild.willMove(toParent: nil)
            boardChild.view.removeFromSuperview()
            boardChild.removeFromParent()
            
            firstChild.token = self.token
            firstChild.id = self.id
            
            
            addChild(firstChild)
            view.addSubview(firstChild.view)
            keywordChild.willMove(toParent: nil)
            keywordChild.view.removeFromSuperview()
            keywordChild.removeFromParent()
            
            firstChild.token = self.token
            firstChild.id = self.id
            
            
            addChild(firstChild)
            view.addSubview(firstChild.view)
            firstChild.didMove(toParent: self)
        }
    }
}
