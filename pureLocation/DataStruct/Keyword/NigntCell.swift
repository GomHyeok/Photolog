//
//  NigntCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//

import Foundation
import UIKit

class NingtCell : UITableViewCell {
    @IBOutlet weak var NigntLabel: UILabel!

    @IBOutlet weak var One: UIButton!
    @IBOutlet weak var Seven: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var Five: UIButton!
    @IBOutlet weak var Four: UIButton!
    @IBOutlet weak var Eight: UIButton!
    @IBOutlet weak var Three: UIButton!
    @IBOutlet weak var Two: UIButton!
    
    var buttons : [UIButton] = []
    
    override func awakeFromNib() {
        self.buttons = [self.One, self.Seven, self.six, self.Five, self.Four, self.Eight, self.Three, self.Two]
        let font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        var cnt = 1

        for setButton in buttons {
            setButton.setAttributedTitle(NSMutableAttributedString(string: setButton.titleLabel?.text ?? "", attributes: buttonAttributes), for: .normal)
            setButton.tag = 1
            setButton.layer.cornerRadius = 16
            setButton.addTarget(self, action: #selector(settingButton), for: .touchUpInside)
            cnt += 1
        }
    }
    
    @objc func settingButton(_ sender : UIButton) {
        let color = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        let colorRed = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        var cnt = 1
        
        for setButton in buttons {
            setButton.setTitleColor(color, for: .normal)
            setButton.setTitleColor(color, for: .highlighted)
            setButton.setTitleColor(color, for: .selected)
            setButton.tag = cnt
            cnt += 1
        }
        
        sender.setTitleColor(colorRed, for: .normal)
        sender.setTitleColor(colorRed, for: .highlighted)
        sender.setTitleColor(colorRed, for: .selected)
        sender.tag *= 10
    }
    
    func getString() -> Int? {
        for button in buttons {
            if button.tag >= 10 {
                return button.tag/10
            }
        }
        return nil
    }
}
