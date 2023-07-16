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
    
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Email.setBottomLine(borderColor: lineColor)
        self.Password.setBottomLine(borderColor: lineColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        print("Login")
        login()
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
    func login() {
        guard let email = Email.text else {return}
        guard let password = Password.text else {return}
        
        print(email)
        print(password)
        
        UserService.shared.login(
            email: email,
            password: password) {
                response in
                switch response {
                case .success(let data) :
                    guard let data = data as? LoginResponse else {return}
                    self.token = data.data?.token ?? ""
                    self.id = data.data?.userId ?? 0
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

extension UITextField {
  func setBottomLine(borderColor: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let borderLine = UIView()
      borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - 0.3, width: Double(self.frame.width), height: 0.3)
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
   }
}
