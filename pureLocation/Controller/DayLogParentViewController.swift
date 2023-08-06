//
//  DayLogParentViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import UIKit

class DayLogParentViewController: UIViewController {
    var secondChild : DayTextViewController!
    
    var token : String = ""
    var id : Int = 0
    var travelId: Int = 0
    var datas : CalculateResponse?
    var cnt : Int = 0
    var locationId : [Int] = []
    var settingData : TravelInfoResponse?
    var urlArray : [URL] = []
    var images : [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        cnt = 0
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        secondChild = storyboard.instantiateViewController(withIdentifier: "DayTextViewController") as? DayTextViewController
        secondChild.delegate = self
        
        travelInfo {
            self.setupSecondChild(cnt: self.cnt)
        }
            
    }
    
    func setupSecondChild(cnt: Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        secondChild = storyboard.instantiateViewController(withIdentifier: "DayTextViewController") as? DayTextViewController
        
        secondChild.delegate = self

        secondChild.token = self.token
        secondChild.id = self.id
        secondChild.travelId = self.travelId
        secondChild.datas = self.settingData
        secondChild.output = self.datas
        secondChild.cnt = cnt
        
        self.addChild(secondChild)
        self.view.addSubview(secondChild.view)
        secondChild.didMove(toParent: self)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension DayLogParentViewController {
    func travelInfo(completion : @escaping () -> Void) {
        UserService.shared.travelInfo(travelId: travelId, token: token) {
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? TravelInfoResponse else {return}
                    self.settingData = data
                    print(data)
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

extension DayLogParentViewController : ChildDelegate {
    
    func tagToText(cnt: Int) {
        
    }
        
    func textToTag(cnt: Int) {
        
    }
    
    
}
