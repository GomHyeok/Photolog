//
//  ResigterViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Password.setBottomLine(borderColor: lineColor)
        self.Email.setBottomLine(borderColor: lineColor)
        self.NickName.setBottomLine(borderColor: lineColor)
        self.NextButton.layer.cornerRadius = 10
        self.NextButton.layer.borderWidth=1
        self.NextButton.layer.borderColor = self.NextButton.backgroundColor?.cgColor
        
        MainTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
        SubTitle.font = UIFont(name: "Pretendard-Regular", size: 21)
        
    }

    @IBAction func RegisterBUtton(_ sender: UIButton) {
        print("Register")
        Password.text = ""
        Email.text = ""
        NickName.text = ""
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
    
    @IBAction func FindPassword(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let passWordView = storyboard.instantiateViewController(withIdentifier: "FindPasswordViewController") as? FindPasswordViewController {
            
            self.navigationController?.pushViewController(passWordView, animated: true)
        }
        else {print("비밀번호 찾기 문제")}
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

