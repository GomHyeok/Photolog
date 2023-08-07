//
//  KeywordViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/31.
//

import UIKit

class KeywordViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0

    @IBOutlet weak var KeywardLabel: UILabel!
    @IBOutlet weak var KeywordTable: UITableView!
    @IBOutlet weak var LabelTom: UILabel!
    @IBOutlet weak var LabelBottom: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        KeywordTable.separatorStyle = .none
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        // KeywardLabel 설정
        let keywardLabelColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let keywardLabelFont = UIFont(name: "Pretendard-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
        let keywardLabelAttributes: [NSAttributedString.Key: Any] = [
            .font: keywardLabelFont,
            .foregroundColor: keywardLabelColor
        ]
        KeywardLabel.attributedText = NSMutableAttributedString(string: KeywardLabel.text ?? "", attributes: keywardLabelAttributes)

        // LabelTom 설정
        let labelTomText = "여행과 관련된 키워드를 선택해 주세요."
        let labelTomColor = UIColor(red: 0.578, green: 0.578, blue: 0.578, alpha: 1)
        let labelTomFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let paragraphStyleTom = NSMutableParagraphStyle()
        paragraphStyleTom.lineHeightMultiple = 1.18
        let labelTomAttributes: [NSAttributedString.Key: Any] = [
            .font: labelTomFont,
            .foregroundColor: labelTomColor,
            .paragraphStyle: paragraphStyleTom
        ]
        LabelTom.attributedText = NSMutableAttributedString(string: labelTomText, attributes: labelTomAttributes)

        // LabelBottom 설정
        let labelBottomText = "상관없으면 선택하지 않아도 좋아요."
        let labelBottomColor = UIColor(red: 0.578, green: 0.578, blue: 0.578, alpha: 1)
        let labelBottomFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let paragraphStyleBottom = NSMutableParagraphStyle()
        paragraphStyleBottom.lineHeightMultiple = 1.18
        let labelBottomAttributes: [NSAttributedString.Key: Any] = [
            .font: labelBottomFont,
            .foregroundColor: labelBottomColor,
            .paragraphStyle: paragraphStyleBottom
        ]
        LabelBottom.attributedText = NSMutableAttributedString(string: labelBottomText, attributes: labelBottomAttributes)

        
        KeywordTable.delegate = self
        KeywordTable.dataSource = self
        
        let footerView = UIView(frame: CGRect(x: 22, y: 0, width: KeywordTable.frame.size.width-22, height: 53))
        let button = UIButton(frame: footerView.bounds)
        button.setTitle("다음", for: .normal)
        button.backgroundColor  = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1.0)
        button.layer.cornerRadius = 24
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        footerView.addSubview(button)
        KeywordTable.tableFooterView = footerView
    }
    
    @objc func backButtonAction() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped() {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let
            Keyword = storyboard.instantiateViewController(withIdentifier: "AfterKeywordViewController") as? AfterKeywordViewController {
            
            Keyword.token = self.token
            Keyword.id = self.id
            
            var filter : [String : String] = [:]

            var indexPath = IndexPath(row: 0, section: 0)
            var cell = KeywordTable.cellForRow(at: indexPath) as! PlaceCell
            if cell.getString() != nil {
                filter["degree"] = cell.getString()
            }
            indexPath = IndexPath(row: 1, section: 0)
            var cell1 = KeywordTable.cellForRow(at: indexPath) as! budgets

            if cell1.getBudget() > 0 {
                var budget = cell1.getBudget()
                filter["endBudget"] = String(budget)
            }

            indexPath = IndexPath(row: 2, section: 0)
            var cell2 = KeywordTable.cellForRow(at: indexPath) as!NingtCell

            if cell2.getString() != nil {
                var day = cell2.getString()!
                filter["day"] = String(day)
            }

            indexPath = IndexPath(row: 3, section: 0)
            var cell3 = KeywordTable.cellForRow(at: indexPath) as!ThemaCell

            if cell3.getString() != nil {
                Keyword.themas = cell3.getString()!
            }

            Keyword.filters = filter
            
            self.navigationController?.pushViewController(Keyword, animated: true)
        }
        else {print("Keyword 문제")}
    }

}

extension KeywordViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        }
        else if indexPath.row == 1 {
            return 125
        }
        else if indexPath.row == 2 {
            return 120
        }
        else if indexPath.row == 3 {
            return 215
        }
        else {
            return 90
        }
    }
}

extension KeywordViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTextColor = UIColor(red: 0.026, green: 0.026, blue: 0.026, alpha: 1)
        let cellTextFont = UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let cellTextAttributes: [NSAttributedString.Key: Any] = [
            .font: cellTextFont,
            .foregroundColor: cellTextColor
        ]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
            cell.PlaceLabel.attributedText = NSMutableAttributedString(string: cell.PlaceLabel.text ?? "", attributes: cellTextAttributes)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "budgets", for: indexPath) as! budgets
            cell.Budget.attributedText = NSMutableAttributedString(string: cell.Budget.text ?? "", attributes: cellTextAttributes)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NingtCell", for: indexPath) as! NingtCell
            cell.NigntLabel.attributedText = NSMutableAttributedString(string: cell.NigntLabel.text ?? "", attributes: cellTextAttributes)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemaCell", for: indexPath) as! ThemaCell
            cell.PlaceLabel.attributedText = NSMutableAttributedString(string: cell.PlaceLabel.text ?? "", attributes: cellTextAttributes)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
            cell.GroupLabel.attributedText = NSMutableAttributedString(string: cell.GroupLabel.text ?? "", attributes: cellTextAttributes)
            return cell
        }
    }
    
    
}
