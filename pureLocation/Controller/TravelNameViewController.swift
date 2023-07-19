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
        let lineColor = UIColor(red:0.58, green:0.25, blue:0.17, alpha:1.0)
        self.NameFiled.setBottomLine(borderColor: lineColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func NextButton(_ sender: UIButton) {
        travelName() {
            print("travelName")
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let
                daylog = storyboard.instantiateViewController(withIdentifier: "DayLogViewController") as? DayLogViewController {
                daylog.token = self.token
                daylog.id = self.id
                daylog.travelId = self.travelId
                daylog.datas = self.datas
                
                self.navigationController?.pushViewController(daylog, animated: true)
            }
            else {print("daylog 문제")}
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
