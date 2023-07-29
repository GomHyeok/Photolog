//
//  LoginViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/15.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var LoginTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    
    var token : String = ""
    var id : Int = 0
    var check : Bool = false
    
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var nexButton: UIButton!
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Email.setBottomLine(borderColor: lineColor)
        self.Password.setBottomLine(borderColor: lineColor)
        self.nexButton.layer.cornerRadius = 10
        self.nexButton.layer.borderWidth=1
        self.nexButton.layer.borderColor = self.nexButton.backgroundColor?.cgColor
        
        LoginTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
        subTitle.font = UIFont(name: "Pretendard-Regular", size: 21)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        check = false
        login() {
            if self.check {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                if let homeView = storyboard.instantiateViewController(withIdentifier: "HomeParentViewController") as? HomeParentViewController {
                    homeView.token = self.token
                    homeView.id = self.id
                    
                    self.navigationController?.pushViewController(homeView, animated: true)
                }
                else {print("홈뷰 문제")}
            }
            else {
                self.alert(message: "로그인에 실패하였습니다.")
            }
        }
    }
    
    @IBAction func SecurityType(_ sender: UIButton) {
        if Password.isSecureTextEntry {
            Password.isSecureTextEntry = false
        }
        else {
            Password.isSecureTextEntry = true
        }
    }
}

extension LoginViewController {
    func login(completion : @escaping () -> Void) {
        guard let email = Email.text else {return}
        guard let password = Password.text else {return}
        
        UserService.shared.login(
            email: email,
            password: password) {
                response in
                switch response {
                case .success(let data) :
                    guard let data = data as? LoginResponse else {return}
                    self.token = data.data?.token ?? ""
                    self.id = data.data?.userId ?? 0
                    self.check = true
                    if(self.check) { print("True") }
                    completion()
                case .requsetErr(let err) :
                    print(err)
                    completion()
                case .pathErr:
                    print("pathErr")
                    completion()
                case .serverErr:
                    print("serverErr")
                    completion()
                case .networkFail:
                    print("networkFail")
                    completion()
                }
            }
    }
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

extension UITextField {
  func setBottomLine(borderColor: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height), width: Double(self.frame.width), height: 0.3)
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
   }
}

extension UILabel {
    func setBottomLine(borderColor: UIColor) {
          self.backgroundColor = UIColor.clear
          let borderLine = UIView()
          borderLine.frame = CGRect(x: 0, y: Double(self.frame.height), width: Double(self.frame.width), height: 0.3)
          borderLine.backgroundColor = borderColor
          self.addSubview(borderLine)
     }
}
