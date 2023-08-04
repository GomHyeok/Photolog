//
//  DeleteBoardViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import UIKit

class DeleteBoardViewController: UIViewController {
    
    var data : BookMarkedArticleResponse?
    
    
    @IBOutlet weak var DeleteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DeleteTable.dataSource = self
        DeleteTable.delegate = self
    }
    
    func getArticleID () -> [Int] {
        var articleId : [Int] = []
        
        for i in 0..<(data?.data?.count ?? 0) {
            let indexPath = IndexPath(row : i, section : 0)
            let cell = DeleteTable.cellForRow(at: indexPath) as! BookMarkBoardDelete
            if cell.DeleteButton.tag % 2 == 1 {
                articleId.append(cell.articleId)
            }
        }
        print(articleId)
        
        return articleId
    }
}

extension DeleteBoardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}

extension DeleteBoardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkBoardDelete", for: indexPath) as! BookMarkBoardDelete
        
        cell.City.text = self.data?.data?[indexPath.row].city
        cell.City.setBottomLine(borderColor: UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0), hight: 0.5, bottom: 0)
        cell.City.font = UIFont(name: "Pretendard-Regular", size: 10)
        
        cell.Title.text = self.data?.data?[indexPath.row].title ?? "제목이 없습니다."
        cell.Title.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        cell.During.text = self.data?.data?[indexPath.row].startDate
        cell.During.text! += " ~ "
        cell.During.text! += self.data?.data?[indexPath.row].endDate ?? ""
        cell.During.font = UIFont(name: "Pretendard-Regular", size: 13)
        
        cell.HartNum.text = String(self.data?.data?[indexPath.row].likes ?? 0)
        cell.HartNum.font = UIFont(name: "Pretendard-Medium", size: 13)
        
        cell.BookMarkNum.text = String(self.data?.data?[indexPath.row].bookmarks ?? 0)
        cell.BookMarkNum.font = UIFont(name: "Pretendard-Medium", size: 13)
        
        cell.BookMarkImage.kf.setImage(with: URL(string: self.data?.data?[indexPath.row].thumbnail ?? "")!)
        
        cell.DeleteButton.tag = 0
        cell.DeleteButton.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        
        cell.articleId = self.data?.data?[indexPath.row].id ?? 0
        
        return cell
    }
    
    @objc func buttonTap (_ sender : UIButton) {
        sender.tag += 1
    }
    
}

