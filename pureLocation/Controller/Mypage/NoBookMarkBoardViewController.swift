//
//  NoBookMarkBoardViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import UIKit

class NoBookMarkBoardViewController: UIViewController {

    @IBOutlet weak var BookMarkLabel: UILabel!
    @IBOutlet weak var BoardButton: UIButton!
    
    var token : String = ""
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BoardButton.layer.cornerRadius = 24
        BookMarkLabel.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
        BoardButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBoard", size: 16)
        
    }
    
    
    @IBAction func board(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let board = storyboard.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController {
            board.token = self.token
            board.id = self.id
            
            self.navigationController?.pushViewController(board, animated: true)
        }
        else {print("board 문제")}
    }
}
