//
//  PlaceCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//

import Foundation
import UIKit

class PlaceCell : UITableViewCell {
    
    @IBOutlet weak var PlaceLabel: UILabel!
    
    @IBOutlet weak var Inchun: UIButton!
    @IBOutlet weak var Seoul: UIButton!
    @IBOutlet weak var DaeGu: UIButton!
    @IBOutlet weak var DaeJon: UIButton!
    @IBOutlet weak var Ulsan: UIButton!
    @IBOutlet weak var Busan: UIButton!
    @IBOutlet weak var Gangju: UIButton!
    @IBOutlet weak var Jeju: UIButton!
    @IBOutlet weak var Gunsangdo: UIButton!
    @IBOutlet weak var Junlado: UIButton!
    @IBOutlet weak var Gungido: UIButton!
    @IBOutlet weak var ChongChungdo: UIButton!
    @IBOutlet weak var Ganwondo: UIButton!
    @IBOutlet weak var SaeJong: UIButton!
    
    var buttons : [UIButton] = []
    var ButtonTablCallBack : (() -> String)?
    
    override func awakeFromNib() {
        self.buttons = [self.Inchun, self.Seoul, self.DaeGu, self.DaeJon, self.Ulsan, self.Busan, self.Gangju, self.Jeju, self.Gunsangdo, self.Junlado, self.Gungido, self.ChongChungdo, self.Ganwondo, self.SaeJong]
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
        
        if(sender.tag == 0) {
            sender.setTitleColor(colorRed, for: .normal)
            sender.setTitleColor(colorRed, for: .highlighted)
            sender.setTitleColor(colorRed, for: .selected)
            sender.tag = 1
        }
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
