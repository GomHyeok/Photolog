//
//  GroupCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//


import Foundation
import UIKit

class GroupCell : UITableViewCell {
    @IBOutlet weak var GroupLabel: UILabel!
    
    @IBOutlet weak var Friend: UIButton!
    @IBOutlet weak var Date: UIButton!
    @IBOutlet weak var Family: UIButton!
    @IBOutlet weak var alon: UIButton!
    
    var buttons : [UIButton] = []
    
    override func awakeFromNib() {
        self.buttons = [self.alon, self.Date, self.Family, self.Friend]
        let font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        for setButton in buttons {
            setButton.setAttributedTitle(NSMutableAttributedString(string: setButton.titleLabel?.text ?? "", attributes: buttonAttributes), for: .normal)
            setButton.tag = 0
            setButton.layer.cornerRadius = 16
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
            setButton.tag = 0
        }
        
        sender.setTitleColor(colorRed, for: .normal)
        sender.setTitleColor(colorRed, for: .highlighted)
        sender.setTitleColor(colorRed, for: .selected)
        sender.tag = 1
    }
    
    func getString() -> String? {
        for button in buttons {
            if button.tag == 1 {
                return button.titleLabel?.text
            }
        }
        return nil
    }
}

