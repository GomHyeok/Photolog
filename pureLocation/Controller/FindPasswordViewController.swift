//
//  FindPasswordViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/16.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NextButton.layer.cornerRadius = 10
        self.NextButton.layer.borderWidth=1
        self.NextButton.layer.borderColor = self.NextButton.backgroundColor?.cgColor
    }
    

}
