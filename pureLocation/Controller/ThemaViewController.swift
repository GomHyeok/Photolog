//
//  ThemaViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/26.
//

import UIKit

class ThemaViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var themas : [String] = []
    var buttons : [UIButton] = []
    let gradientLayer = CAGradientLayer()
    
    
    @IBOutlet weak var CustomBackground: UIView!
    @IBOutlet weak var BackGroundImage: UIImageView!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var MainTitle: UILabel!
    
    @IBOutlet weak var Friend: UIButton!
    @IBOutlet weak var Cruise: UIButton!
    @IBOutlet weak var Echo: UIButton!
    @IBOutlet weak var Date: UIButton!
    @IBOutlet weak var Family: UIButton!
    
    @IBOutlet weak var City: UIButton!
    @IBOutlet weak var Stay: UIButton!
    @IBOutlet weak var Nature: UIButton!
    @IBOutlet weak var BackPacking: UIButton!
    @IBOutlet weak var Culture: UIButton!
    
    @IBOutlet weak var Adventure: UIButton!
    @IBOutlet weak var Luxury: UIButton!
    @IBOutlet weak var Vacation: UIButton!
    @IBOutlet weak var Article: UIButton!
    @IBOutlet weak var shopping: UIButton!
    @IBOutlet weak var camp: UIButton!
    @IBOutlet weak var spa: UIButton!
    
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
        
        BackGroundImage.load(url: URL(string : self.datas?.data?.locationImg[0] ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        let font = UIFont(name: "Pretendard-Regular", size: 16)
        MainTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
        SubTitle.font = UIFont(name: "Pretendard-Regular", size: 14)
        NextButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        NextButton.layer.cornerRadius = 10
        
        buttons = [Friend, Cruise, Echo, Date, Family, City, Stay
        , Nature, BackPacking, Culture, Adventure, Luxury, Vacation, Article, shopping, camp, spa]
        
        for setButton in buttons {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = setButton.frame.width/10
        }
        
        
    }

    @IBAction func ButtonsAction(_ sender: UIButton) {
        sender.tag += 1
        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        DispatchQueue.main.async {
            if sender.tag % 2 == 1 {
                print(sender.tag)
                let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                sender.setTitleColor(color, for: .normal)
                sender.setTitleColor(color, for: .highlighted)
                sender.setTitleColor(color, for: .selected)
            }
            else {
                let color = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
                sender.setTitleColor(color, for: .normal)
                sender.setTitleColor(color, for: .highlighted)
                sender.setTitleColor(color, for: .selected)
            }
        }
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        var theme : [String] = []
        for setButton in self.buttons {
            if setButton.tag % 2 == 1 {
                theme.append((setButton.titleLabel?.text ?? ""))
            }
        }
        
        Theme(theme: theme) {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let
                daylog = storyboard.instantiateViewController(withIdentifier: "DayLogParentViewController") as? DayLogParentViewController {
                daylog.token = self.token
                daylog.id = self.id
                daylog.travelId = self.travelId
                daylog.datas = self.datas
                
                self.navigationController?.pushViewController(daylog, animated: true)
            }
            else {print("daylog 문제")}
        }
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension ThemaViewController {
    func Theme (theme : [String], completion : @escaping () -> Void) {
        UserService.shared.Theme(token: token, travelId: travelId, theme: theme ) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? staticResponse else {return}
                        print(data)
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
}
