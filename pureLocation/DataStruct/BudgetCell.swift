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
    
    @IBOutlet weak var Groups: UILabel!
    @IBOutlet weak var Date: UIButton!
    @IBOutlet weak var Family: UIButton!
    @IBOutlet weak var alon: UIButton!
    @IBOutlet weak var Friend: UIButton!
    
    var buttons : [UIButton] = []
    var groupButton : [UIButton] = []
    
    
    override func awakeFromNib() {
        self.buttons = [self.under20, self.for40, self.for60, self.for80, self.for100, self.above100]
        self.groupButton = [self.alon, self.Friend, self.Family, self.Date]
        
        let font = UIFont(name: "Pretendard-Regular", size: 14)
        var cnt = 1
        
        for setButton in buttons {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = 14
            setButton.addTarget(self, action: #selector(settingButton), for: .touchUpInside)
            setButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            setButton.tag = cnt*20
            cnt+=1
        }
        
        for setButton in groupButton {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = 14
            setButton.addTarget(self, action: #selector(settingGroup), for: .touchUpInside)
            setButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
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
            setButton.tag = cnt*20
            cnt+=1
        }
        
        sender.setTitleColor(colorRed, for: .normal)
        sender.setTitleColor(colorRed, for: .highlighted)
        sender.setTitleColor(colorRed, for: .selected)
        sender.tag = sender.tag * 100
    }
    
    @objc func settingGroup(_ sender : UIButton) {
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
        if sender.tag == 0 {
            sender.setTitleColor(colorRed, for: .normal)
            sender.setTitleColor(colorRed, for: .highlighted)
            sender.setTitleColor(colorRed, for: .selected)
            sender.tag = 1
        }
    }
    
    func getBudget() -> Int {
        var budget : Int = 0
        for setButton in buttons {
            if setButton.tag > 100 {
                budget = setButton.tag/100
                break
            }
        }
        return budget
    }
    
    func getGroup() -> String {
        var st : String = ""
        for setButton in groupButton {
            if setButton.tag == 1 {
                st = setButton.titleLabel?.text ?? ""
                break
            }
        }
        return st
    }
    
}
