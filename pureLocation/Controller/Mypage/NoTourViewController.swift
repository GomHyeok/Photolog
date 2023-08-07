//
//  NoTourViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/04.
//

import UIKit

class NoTourViewController: UIViewController {
    weak var delegate: ViewControllerBDelegate?

    @IBOutlet weak var TourLabel: UILabel!
    @IBOutlet weak var TourButton: UIButton!
    
    var token : String = ""
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TourLabel.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
        
        TourButton.layer.cornerRadius = 24
        TourButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
    }
    
    @IBAction func FindTour(_ sender: UIButton) {
        delegate?.callFunctionInViewControllerB()
    }
}
