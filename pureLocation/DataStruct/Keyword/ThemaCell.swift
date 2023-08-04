//
//  ThemaCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//

import Foundation
import UIKit

class ThemaCell: UITableViewCell {
    @IBOutlet weak var ThemaCell: UIView!
    
    @IBOutlet weak var PlaceLabel: UILabel!
    @IBOutlet weak var Friend: UIButton!
    @IBOutlet weak var Cruise: UIButton!
    @IBOutlet weak var Echo: UIButton!
    @IBOutlet weak var Date: UIButton!
    @IBOutlet weak var Family: UIButton!
    
    @IBOutlet weak var City: UIButton!
    @IBOutlet weak var Stay: UIButton!
    @IBOutlet weak var Nature: UIButton!
    @IBOutlet weak var BackPacking: UIButton!
    @IBOutlet weak var Culture: UIButton!
    
    @IBOutlet weak var Adventure: UIButton!
    @IBOutlet weak var Luxury: UIButton!
    @IBOutlet weak var Vacation: UIButton!
    @IBOutlet weak var Article: UIButton!
    @IBOutlet weak var shopping: UIButton!
    @IBOutlet weak var camp: UIButton!
    @IBOutlet weak var spa: UIButton!
    var buttons : [UIButton] = []
    
    override func awakeFromNib() {
        self.buttons = [self.Friend, self.Cruise, self.Echo, self.Date, self.Family, self.City, self.Stay, self.Nature, self.BackPacking, self.Culture, self.Adventure, self.Luxury, self.Vacation, self.Article, self.shopping, self.camp, self.spa]
        let font = UIFont(name: "Pretendard-Regular", size: 14)
        
        for setButton in buttons {
            setButton.titleLabel?.font = font
            setButton.tag = 0
            setButton.layer.cornerRadius = 16
            setButton.addTarget(self, action: #selector(ButtonsAction), for: .touchUpInside)
            setButton.titleLabel?.font = UIFont(name: "Pretandard-Regular", size: 14)
        }
    }
    
    
    @IBAction func ButtonsAction(_ sender: UIButton) {
        sender.tag += 1
        let red: CGFloat = 255.0 / 255.0
        let green: CGFloat = 112.0 / 255.0
        let blue: CGFloat = 66.0 / 255.0
        DispatchQueue.main.async {
            if sender.tag % 2 == 1 {
                print(sender.tag)
                let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                sender.setTitleColor(color, for: .normal)
                sender.setTitleColor(color, for: .highlighted)
                sender.setTitleColor(color, for: .selected)
            }
            else {
                let color = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
                sender.setTitleColor(color, for: .normal)
                sender.setTitleColor(color, for: .highlighted)
                sender.setTitleColor(color, for: .selected)
            }
        }
    }
    
    func getString() -> [String]? {
        var st : [String]?
        for button in buttons {
            if button.tag == 1 {
                st?.append(button.titleLabel?.text! ?? "")
            }
        }
        return st
    }
}

