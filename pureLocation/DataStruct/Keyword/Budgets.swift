//
//  Budgets.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/01.
//

import Foundation
import UIKit

class budgets : UITableViewCell {
    
    @IBOutlet weak var Budget: UILabel!
    
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var moreTen: UIButton!
    @IBOutlet weak var ten: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var four: UIButton!
    
    var buttons : [UIButton] = []
    
    override func awakeFromNib() {
        self.buttons = [self.two, self.four, self.six, self.eight, self.ten, self.moreTen]
        let font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

        for setButton in buttons {
            setButton.setAttributedTitle(NSMutableAttributedString(string: setButton.titleLabel?.text ?? "", attributes: buttonAttributes), for: .normal)
            setButton.tag = 0
            setButton.layer.cornerRadius = 16
            setButton.addTarget(self, action: #selector(ButtonsAction), for: .touchUpInside)
        }
    }
    
    @IBAction func ButtonsAction(_ sender: UIButton) {
        let color = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        let colorRed = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        var cnt = 1
        
        var check = false
        if sender.tag <= 200 {check = true}
        
        for setButton in buttons {
            setButton.setTitleColor(color, for: .normal)
            setButton.setTitleColor(color, for: .highlighted)
            setButton.setTitleColor(color, for: .selected)
            setButton.tag = cnt*20
            cnt+=1
        }
        
        if check {
            sender.setTitleColor(colorRed, for: .normal)
            sender.setTitleColor(colorRed, for: .highlighted)
            sender.setTitleColor(colorRed, for: .selected)
            sender.tag = sender.tag * 100
        }
    }
    
    func getBudget() -> Int {
        var budget : Int = 0
        for setButton in buttons {
            if setButton.tag > 120 {
                budget = setButton.tag/100
                break
            }
        }
        return budget*10000
    }
}
