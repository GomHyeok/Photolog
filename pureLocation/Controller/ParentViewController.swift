//
//  ParentViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/27.
//

import UIKit

class ParentViewController: UIViewController, ChildViewControllerDelegate {
    
    var firstChild : TotalViewController!
    var secondChild : TotalMapViewController!
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var check : Bool = false
    var settingData : TravelInfoResponse?
    
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            let border = CALayer()
            let width = CGFloat(0.5)
            border.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
            border.frame = CGRect(x: 20, y: self.TopView.frame.size.height - width, width:  self.TopView.frame.size.width, height: width)
            border.borderWidth = width
            self.TopView.layer.addSublayer(border)
            self.TopView.layer.masksToBounds = true
            
            let upper = CALayer()// 선의 두께
            upper.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor// 선의 색상
            upper.frame = CGRect(x: 0, y: 0, width:  self.TopView.frame.size.width, height: width) // 상단에 선을 추가하기 위해 y: 0으로 설정
            upper.borderWidth = width
            self.TopView.layer.addSublayer(upper)
            self.TopView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var TextButton: UIButton!
    @IBOutlet weak var TitleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        TitleName.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        
        NextButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        NextButton.layer.cornerRadius = 24
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonAction))
        saveButton.tintColor = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = saveButton
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        firstChild = storyboard.instantiateViewController(withIdentifier: "TotalViewController") as? TotalViewController
        secondChild = storyboard.instantiateViewController(withIdentifier: "TotalMapViewController") as? TotalMapViewController
        
        firstChild.token = self.token
        firstChild.id = self.id
        firstChild.travelId = self.travelId
        firstChild.datas = self.datas
        
        // delegate 설정
        firstChild.delegate = self
        secondChild.delegate = self
        // 첫 번째 자식 뷰 컨트롤러를 추가합니다.
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
        
        travelInfo {
            DispatchQueue.main.async {
                self.TitleName.text = self.settingData?.data?.title ?? "여행 제목을 찾을 수 없습니다."
                let days = self.settingData?.data?.days ?? []
            }
        }
    }
    
    func switchTotaltToMap() {
        firstChild.willMove(toParent: nil)
        firstChild.view.removeFromSuperview()
        firstChild.removeFromParent()
        
        secondChild.token = self.token
        secondChild.id = self.id
        secondChild.travelId = self.travelId
        secondChild.datas = self.datas
        
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
        firstChild.travelId = self.travelId
        firstChild.datas = self.datas
        
        // 두 번째 자식 뷰 컨트롤러를 추가합니다.
        addChild(firstChild)
        view.addSubview(firstChild.view)
        firstChild.didMove(toParent: self)
    }
    
    
    @IBAction func NextButton(_ sender: Any) {
    }
    
    
    @IBAction func TextAction(_ sender: UIButton) {
    }
    
    
    @IBAction func MapAction(_ sender: Any) {
    }
    
    @objc func backButtonAction() {
        if check {
            self.navigationController?.isNavigationBarHidden = true
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {
        alert(message: "게시물을 저장하지 않고 종료하시겠습니까?")
    }
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let homeView = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController {
                homeView.token = self.token
                homeView.id = self.id
                homeView.travelId = self.travelId
                homeView.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(homeView, animated: true)
            }
            else {print("home 문제")}
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)

        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }

}


extension ParentViewController {
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
