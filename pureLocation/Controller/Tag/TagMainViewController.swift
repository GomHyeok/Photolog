//
//  TagMainViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class TagMainViewController: UIViewController {
    weak var delegate : homeDelegate?
    
    var token : String = ""
    var id : Int = 0
    let filters : [String : String] = [:]
    var articleData : ArticlesFilteringResponse!
    var currentVC : UIViewController!
    var tag : String = ""
    
    @IBOutlet weak var BoardButton: UIButton!
    @IBOutlet weak var TourButton: UIButton!
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArticleFiltering {
            let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
            
            initialViewController.token = self.token
            initialViewController.id = self.id
            initialViewController.articleData = self.articleData
            initialViewController.kind = false
            
            self.addChild(initialViewController)
            initialViewController.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(initialViewController.view)
            initialViewController.didMove(toParent: self)
            
            self.currentVC = initialViewController
        }
        BoardButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
    }
    
    @IBAction func Search(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        
        self.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    @IBAction func Home(_ sender: UIButton) {
        delegate?.switchToHome()
    }
    
    
    @IBAction func goBoard(_ sender: Any) {
        delegate?.switchToBoard()
    }
    
    
    @IBAction func myPage(_ sender: UIButton) {
        delegate?.switchToMypage()
    }
    
    @IBAction func Board(_ sender: UIButton) {
        self.BoardButton.setBottomLines(borderColor: UIColor.black, hight: 2.0, bottom: 5)
        self.TourButton.setBottomLines(borderColor: UIColor.white, hight: 2.0, bottom: 5)
        ArticleFiltering {
            let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagCollectionViewController") as! TagCollectionViewController
            
            initialViewController.token = self.token
            initialViewController.id = self.id
            initialViewController.articleData = self.articleData
            initialViewController.kind = false
            
            self.addChild(initialViewController)
            initialViewController.view.frame = self.ContainerView.bounds
            self.ContainerView.addSubview(initialViewController.view)
            initialViewController.didMove(toParent: self)
            
            self.currentVC = initialViewController
        }
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
}

extension TagMainViewController {
    func ArticleFiltering(completion: @escaping () -> Void) {
        UserService.shared.ArticleFiltering(token: token, Filters: filters, thema: []) {
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
}
