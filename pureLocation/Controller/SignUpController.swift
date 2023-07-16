//
//  SignUpController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        print("Sign up")
        signUp()
    }
}

extension SignUpController {
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
