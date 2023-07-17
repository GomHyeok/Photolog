//
//  SummaryViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?
    var info : UserInfoResponse?

    @IBOutlet weak var NameAndPhoto: UILabel!
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var EndDay: UILabel!
    @IBOutlet weak var StartDay: UILabel!
    @IBOutlet weak var PlaceNum: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        userInfo(){ [self] in
            print("userInfo")
            self.NameAndPhoto.text = (self.info?.data?.nickName ?? "홍길동")
            self.NameAndPhoto.text = (self.NameAndPhoto.text ?? "") + "님의 "
            self.NameAndPhoto.text  = (self.NameAndPhoto.text ?? "") + String(self.datas?.data?.photoNum ?? 0) + "장의 사진을"
        }
        
        Days.text = String(datas?.data?.night ?? 0) + "박" + String(datas?.data?.day ?? 0) + "일"
        StartDay.text = datas?.data?.startDate ?? ""
        EndDay.text = datas?.data?.endDate ?? ""
        PlaceNum.text = "총" + String(datas?.data?.locationNum ?? 0)+"군데를"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func NexButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let
            travelName = storyboard.instantiateViewController(withIdentifier: "TravelNameViewController") as? TravelNameViewController {
            travelName.token = self.token
            travelName.id = self.id
            travelName.travelId = self.travelId
            travelName.datas = self.datas
            
            self.navigationController?.pushViewController(travelName, animated: true)
        }
        else {print("summary 문제")}
    }
    
}

extension SummaryViewController {
    func userInfo(completion: @escaping () -> Void) {
        UserService.shared.userInfo(id: id, token: token) {
                response in
                switch response {
                    case .success(let data) :
                    guard let data = data as? UserInfoResponse else {return}
                        self.info = data
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
