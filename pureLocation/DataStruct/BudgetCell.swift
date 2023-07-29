//
//  BudgetCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/29.
//

import Foundation
import UIKit

class BudgetCell : UITableViewCell {
    
    @IBOutlet weak var Budget: UILabel!
    @IBOutlet weak var under20: UIButton!
    @IBOutlet weak var for40: UIButton!
    @IBOutlet weak var for60: UIButton!
    @IBOutlet weak var for80: UIButton!
    @IBOutlet weak var for100: UIButton!
    @IBOutlet weak var above100: UIButton!
    
    var buttons : [UIButton] = []
    
    
    override func awakeFromNib() {
        self.buttons = [self.under20, self.for40, self.for60, self.for80, self.for100, self.above100]
        let font = UIFont(name: "Pretendard-Regular", size: 14)
        
        for setButton in buttons {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = setButton.frame.width/10
            setButton.addTarget(self, action: #selector(settingButton), for: .touchUpInside)
        }
    }
    
    @objc func settingButton(_ sender : UIButton) {
        let color = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        let colorRed = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        for setButton in buttons {
            setButton.setTitleColor(color, for: .normal)
            setButton.setTitleColor(color, for: .highlighted)
            setButton.setTitleColor(color, for: .selected)
        }
        
        sender.setTitleColor(colorRed, for: .normal)
        sender.setTitleColor(colorRed, for: .highlighted)
        sender.setTitleColor(colorRed, for: .selected)
    }
    
}
