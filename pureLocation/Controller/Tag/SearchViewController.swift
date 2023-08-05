//
//  SearchViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var Search: UITextField!
    var token : String = ""
    var id : Int = 0
    var tag : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        Search.delegate = self
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        
        tag = textField.text!

        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TagMainViewController") as! TagMainViewController
        
        initialViewController.token = self.token
        initialViewController.id = self.id
        initialViewController.tag = self.tag
        initialViewController.navigationController?.isNavigationBarHidden = true
        
        self.navigationController?.pushViewController(initialViewController, animated: true)

        return true
    }
}
