//
//  NoBookMarkBoardViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import UIKit

class NoBookMarkBoardViewController: UIViewController {
    weak var delegate : homeDelegate?

    @IBOutlet weak var BookMarkLabel: UILabel!
    @IBOutlet weak var BoardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BoardButton.layer.cornerRadius = 24
        BookMarkLabel.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
        BoardButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
        
    }
    
    
    @IBAction func board(_ sender: UIButton) {
        delegate?.switchToBoard()
    }
}
