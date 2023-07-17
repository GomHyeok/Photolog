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

    @IBOutlet weak var NameFiled: UITextField!
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor(red:256, green:112, blue:66, alpha:1.0)
        self.NameFiled.setBottomLine(borderColor: lineColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        travelName() {
            print("travelName")
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
}
