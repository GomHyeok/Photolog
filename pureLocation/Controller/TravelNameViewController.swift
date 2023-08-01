//
//  TravelNameViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit

class TravelNameViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId: Int = 0
    var datas : CalculateResponse?
    var imageInfo : [String] = []
    let gradientLayer = CAGradientLayer()

    @IBOutlet weak var PhotoName: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var NameFiled: UITextField!
    @IBOutlet weak var CustomBackground: UIView!
    @IBOutlet weak var TravelName: UILabel!
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = CustomBackground.bounds
        let colors: [CGColor] =  [
            .init(red: 1, green: 1, blue: 1, alpha: 1),
            .init(red: 1, green: 1, blue: 1, alpha: 0.1)
        ]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.4, 0.7]
        CustomBackground.layer.addSublayer(gradientLayer)
        
        backgroundImage.load(url: URL(string : self.datas?.data?.locationImg[0] ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.NextButton.layer.cornerRadius = 10
        self.NextButton.layer.borderWidth=1
        self.NextButton.layer.borderColor = self.NextButton.backgroundColor?.cgColor
        
        NameFiled.borderStyle = .roundedRect

        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        NameFiled.layer.borderColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        NameFiled.layer.borderWidth = 1.0
        NameFiled.layer.cornerRadius = 9
        
        NameFiled.font = UIFont(name: "Pretendard-Regular", size: 16)
        PhotoName.font = UIFont(name: "Pretendard-Regular", size: 14)
        TravelName.font = UIFont(name: "Pretendard-Bold", size: 24)
        NextButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        travelName() {
            print("travelName")
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let
                Thema = storyboard.instantiateViewController(withIdentifier: "ThemaViewController") as? ThemaViewController {
                Thema.token = self.token
                Thema.id = self.id
                Thema.travelId = self.travelId
                Thema.datas = self.datas
                
                self.navigationController?.pushViewController(Thema, animated: true)
            }
            else {print("Thema 문제")}
        }
    }
    
}

extension TravelNameViewController {
    func travelName(completion : @escaping () -> Void) {
        let title = NameFiled.text!
        
        UserService.shared.travelName(id: id, token: token, travelId: travelId, title: title) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? TravelNameResponse else {return}
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
    
    func locationInfo(locationId : Int, completion : @escaping () -> Void) {
        UserService.shared.locationInfo(locationId: locationId, token: token) {
            response in
            switch response {
                case .success(let data) :
                    guard let data = data as? LocationInfoResponse else {return}
                    print(data)
                    self.imageInfo = data.data?.urlList ?? []
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
