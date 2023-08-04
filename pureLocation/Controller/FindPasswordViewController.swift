//
//  FindPasswordViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        self.NextButton.layer.cornerRadius = 10
        self.NextButton.layer.borderWidth=1
        self.NextButton.layer.borderColor = self.NextButton.backgroundColor?.cgColor
        MainTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
        Subtitle.font = UIFont(name: "Pretendard-Regular", size: 21)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

}
