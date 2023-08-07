//
//  TagMainViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class TagMainViewController: UIViewController, UITextFieldDelegate {
    var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    let filters : [String : String] = [:]
    var articleData : ArticlesFilteringResponse!
    var currentVC : UIViewController!
    var tag : [String] = []
    var buttonScrollView = UIScrollView()
    
    @IBOutlet weak var ButtonContainer: UIView!
    @IBOutlet weak var BoardButton: UIButton!
    @IBOutlet weak var TourButton: UIButton!
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        initialViewController.kind = false
        initialViewController.tag = self.tag
        
        self.addChild(initialViewController)
        initialViewController.view.frame = self.ContainerView.bounds
        self.ContainerView.addSubview(initialViewController.view)
        initialViewController.didMove(toParent: self)
        
        self.currentVC = initialViewController
        
        createScrollViewWithButtons()
            
        BoardButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
    }
    
    @IBAction func Search(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        initialViewController.tags = self.tag
        
        self.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    @IBAction func Home(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let home = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController{
            home.token = self.token
            home.id = self.id
            
            home.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    
    @IBAction func goBoard(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let home = storyboard.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController{
            home.token = self.token
            home.id = self.id
            
            home.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    
    @IBAction func myPage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        if let home = storyboard.instantiateViewController(withIdentifier: "MyPageMainViewController") as? MyPageMainViewController{
            home.token = self.token
            home.id = self.id
            
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    @IBAction func Map(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Place", bundle: nil)
        if let home = storyboard.instantiateViewController(withIdentifier: "PlaceMainViewController") as? PlaceMainViewController{
            home.token = self.token
            home.id = self.id
            
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    @IBAction func Board(_ sender: UIButton) {
        self.BoardButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        self.TourButton.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        initialViewController.kind = false
        initialViewController.tag = self.tag
        
        self.addChild(initialViewController)
        initialViewController.view.frame = self.ContainerView.bounds
        self.ContainerView.addSubview(initialViewController.view)
        initialViewController.didMove(toParent: self)
        
        self.currentVC = initialViewController
    }
    
    
    @IBAction func Tour(_ sender: UIButton) {
        self.BoardButton.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
        self.TourButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        initialViewController.kind = true
        initialViewController.tag = self.tag
        
        self.addChild(initialViewController)
        initialViewController.view.frame = self.ContainerView.bounds
        self.ContainerView.addSubview(initialViewController.view)
        initialViewController.didMove(toParent: self)
        
        self.currentVC = initialViewController
    }
    
    func createScrollViewWithButtons() {
        // Initialize the ScrollView and add it to buttonContainer.
        buttonScrollView = UIScrollView()
        buttonScrollView.translatesAutoresizingMaskIntoConstraints = false
        ButtonContainer.addSubview(buttonScrollView)

        // Set the constraints for the ScrollView.
        NSLayoutConstraint.activate([
            buttonScrollView.topAnchor.constraint(equalTo: ButtonContainer.topAnchor),
            buttonScrollView.bottomAnchor.constraint(equalTo: ButtonContainer.bottomAnchor),
            buttonScrollView.leadingAnchor.constraint(equalTo: ButtonContainer.leadingAnchor),
            buttonScrollView.trailingAnchor.constraint(equalTo: ButtonContainer.trailingAnchor)
        ])

        // Create a horizontal StackView to contain the buttons.
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonScrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: buttonScrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: buttonScrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: buttonScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: buttonScrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: buttonScrollView.heightAnchor)
        ])

        // For each tag, create a button and add it to the StackView.
        var cnt = 0
        for title in tag {
            let button = UIButton(type: .system)
            button.tag = cnt
            cnt += 1
            button.setTitle(("    " + title + "  x   "), for: .normal)
            button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // Set your preferred color
            button.setTitleColor(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0), for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
            button.layer.cornerRadius = 16
            button.addTarget(self, action: #selector(removeTag), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func removeTag (_ sender : UIButton) {
        // tag array에서 해당 태그를 제거합니다.
        tag.remove(at: sender.tag)

        // 해당 버튼을 스택뷰에서 제거합니다.
        if let stackView = sender.superview as? UIStackView {
            sender.removeFromSuperview()

            // 버튼의 태그를 업데이트합니다.
            for (index, button) in stackView.arrangedSubviews.enumerated() where button is UIButton {
                button.tag = index
            }
            
            self.BoardButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
            self.TourButton.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
            let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
            
            initialViewController.token = self.token
            initialViewController.id = self.id
            initialViewController.kind = false
            initialViewController.tag = self.tag
            
            self.addChild(initialViewController)
            initialViewController.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(initialViewController.view)
            initialViewController.didMove(toParent: self)
            
            self.currentVC = initialViewController
        }
    }
}
