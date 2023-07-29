//
//  HomeParentViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit

class HomeParentViewController: UIViewController, ChildViewControllerDelegate {
    
    var firstChild : HomeViewController!
    var secondChild : HomeNameViewController!
    var token : String = ""
    var id : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 뷰 버튼 수정
        let backButton = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(backButtonAction))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        firstChild = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        secondChild = storyboard.instantiateViewController(withIdentifier: "HomeNameViewController") as? HomeNameViewController
        
        firstChild.token = self.token
        firstChild.id = self.id
        
        // delegate 설정
        firstChild.delegate = self
        secondChild.delegate = self
        // 첫 번째 자식 뷰 컨트롤러를 추가합니다.
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func switchTotaltToMap() {
        firstChild.willMove(toParent: nil)
        firstChild.view.removeFromSuperview()
        firstChild.removeFromParent()
        
        secondChild.token = self.token
        secondChild.id = self.id
        
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
        
        // 두 번째 자식 뷰 컨트롤러를 추가합니다.
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
}
