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
        
        if let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction))
            
            navigationItem.leftBarButtonItem = backButton
        } else {
            print("backButton image not found")
        }
        
        KeywardLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        LabelTom.font = UIFont(name: "Pretendard_Regular", size: 14)
        LabelBottom.font = UIFont(name: "Pretendard_Regular", size: 14)
        
        KeywordTable.delegate = self
        KeywordTable.dataSource = self
        
        let footerView = UIView(frame: CGRect(x: 20, y: 0, width: KeywordTable.frame.size.width-20, height: 40))
        let button = UIButton(frame: footerView.bounds)
        button.setTitle("다음", for: .normal)
        button.backgroundColor  = UIColor(red: 255/255, green: 112/255, blue: 66/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        footerView.addSubview(button)
        KeywordTable.tableFooterView = footerView
    }
    
    @objc func backButtonAction() {
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
            return 200
        }
        else if indexPath.row < 3 {
            return 150
        }
        else if indexPath.row == 3 {
            return 250
        }
        else {
            return 100
        }
    }
}

extension KeywordViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
            
            cell.PlaceLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "budgets", for: indexPath) as! budgets
            
            cell.Budget.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NingtCell", for: indexPath) as! NingtCell
            
            cell.NigntLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemaCell", for: indexPath) as! ThemaCell
            
            cell.PlaceLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
            
            cell.GroupLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
            
            return cell
        }
    }
    
    
}
