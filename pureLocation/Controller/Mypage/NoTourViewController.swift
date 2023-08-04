//
//  NoTourViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/04.
//

import UIKit

class NoTourViewController: UIViewController {

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
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let board = storyboard.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController {
            board.token = self.token
            board.id = self.id
            
            self.navigationController?.pushViewController(board, animated: true)
        }
        else {print("board 문제")}
    }
}
