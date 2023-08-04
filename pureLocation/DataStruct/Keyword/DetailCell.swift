//
//  DetailCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//

import Foundation
import UIKit

class DetailCell : UITableViewCell {
    @IBOutlet weak var PlaceLabel: UILabel!
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button10: UIButton!
    @IBOutlet weak var Button9: UIButton!
    
    var buttons : [UIButton] = []
    
    override func awakeFromNib() {
        self.buttons = [self.Button1, self.Button2, self.Button3, self.Button4, self.Button5, self.Button6, self.Button7, self.Button8, self.Button9, self.Button10]
        let font = UIFont(name: "Pretendard-Regular", size: 14)
        
        for setButton in buttons {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = 16
            setButton.addTarget(self, action: #selector(settingButton), for: .touchUpInside)
            setButton.titleLabel?.font = UIFont(name: "Pretandard-Regular", size: 14)
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
