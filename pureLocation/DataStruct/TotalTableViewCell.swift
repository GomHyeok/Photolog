//
//  TotalTableViewCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/19.
//

import Foundation
import UIKit

class TotalTableViewCell : UITableViewCell {
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var ButtonLabel: UITextView!
    @IBOutlet weak var ButtonImage: UIImageView!
    @IBOutlet weak var BackGroundImage: UIImageView!
    
    var row : Int = 0
    var col : Int = 0
}
