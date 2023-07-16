//
//  ResigterViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var NickName: UITextField!
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Password.setBottomLine(borderColor: lineColor)
        self.Email.setBottomLine(borderColor: lineColor)
        self.NickName.setBottomLine(borderColor: lineColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func RegisterBUtton(_ sender: UIButton) {
        print("Register")
        signUp()
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

extension RegisterViewController {
    func signUp() {
        guard let email = Email.text else {return}
        guard let nickname = NickName.text else {return}
        guard let password = Password.text else {return}
        
        print(email)
        print(nickname)
        print(password)
        
        //서버 통신 서비스 코드를 싱글톤 변수를 통해 접근
        //호출 후 받은 응답을 통한 처리
        UserService.shared.singUp(
            email: email,
            nickName: nickname,
            password: password) {
                response in
                switch response {
                    case .success(let data) :
                        guard let data = data as? SignupResponse else {return}
                        print(data)
                        self.alert(message : data.message)
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
    
    func alert(message : String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

