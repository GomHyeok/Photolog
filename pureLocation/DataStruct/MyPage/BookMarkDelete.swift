//
//  BookMarkDelete.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import Foundation
import UIKit

class BookMarkBoardDelete : UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var During: UILabel!
    
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var BookMarkImage: UIImageView!
    @IBOutlet weak var BookMarkNum: UILabel!
    @IBOutlet weak var HartNum: UILabel!
    @IBOutlet weak var BookMark: UIImageView!
    @IBOutlet weak var Hart: UIImageView!
    
    var articleId : Int = 0
}
