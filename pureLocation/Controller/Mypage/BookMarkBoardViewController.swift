//
//  BookMarkBoardViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import UIKit

class BookMarkBoardViewController: UIViewController {
    
    @IBOutlet weak var BookMarkTable: UITableView!
    
    var data : BookMarkedArticleResponse?
    var token : String = ""
    var id : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BookMarkTable.delegate = self
        BookMarkTable.dataSource = self
    }

}

extension BookMarkBoardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
}

extension BookMarkBoardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkBoard", for: indexPath) as! BookMarkBoard
        
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
        
        cell.CellButton.tag = self.data?.data?[indexPath.row].id ?? 0
        cell.CellButton.addTarget(self, action: #selector(articleButton), for: .touchUpInside)
        
        cell.BookMarkImage.layer.cornerRadius = 5
        
        return cell
    }
    
    @objc func articleButton (_ sender : UIButton) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        if let boardView = storyboard.instantiateViewController(withIdentifier: "BoardViewController") as? BoardViewController {
            
            boardView.token = self.token
            boardView.id = self.id
            boardView.ArticleId = sender.tag
            
            
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else {print("board 문제")}
    }
}
