//
//  DayLogTextCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/28.
//

import Foundation
import UIKit

class DayLogTextCell : UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    var data : [URL] = []
    var token : String = ""
    var locationId : Int = 0
    var st : String = ""
    var index : Int?
    
    weak var delegate: DayLogTextCellDelegate?

    
    @IBOutlet weak var AIButton: UIButton!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var LocationName: UITextField!
    @IBOutlet weak var BackGroundImage: UIImageView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var DayLogCollection: UICollectionView!
    @IBOutlet weak var ping: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.DayLogCollection.delegate = self
        self.DayLogCollection.dataSource = self
        
        Description.delegate = self
        LocationName.delegate = self
        
        self.AIButton.addTarget(self, action: #selector(buttontouch), for: .touchUpInside)
        
        if let layout = DayLogCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: DayLogCollection.bounds.width / 2, height: DayLogCollection.bounds.height)
        }
    }
    
    
    func setData(_ newData: [URL]) {
        self.data = newData
        DispatchQueue.main.async {
            self.DayLogCollection.reloadData()
        }
    }
    
    @objc func buttontouch (_ sender : UIButton) {
        delegate?.didTapAIButton(in: self)
        var keyword : [String] = []
        sender.setImage(UIImage(named: "wand"), for: .normal)
        keyword = self.Description.text.split(separator: ",").map(String.init)
        
        if LocationName.text != "장소명을 입력해주세요" {
            keyword.append(LocationName.text ?? "")
        }
        
        Review(locationId: self.locationId, keyword: keyword) {
            self.delegate?.didTapAIButtons(in: self)
            self.typeTextAnimation(text: self.st)
        }
    }
    
    func typeTextAnimation(text: String) {
        Description.text = ""
        let characters = Array(text)
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if index < characters.count {
                self.Description.text?.append(characters[index])
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "정보를 입력해주세요" {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let index = index else {
            print("index is nil")
            return
        }
        if textView == Description {
            delegate?.textViewDidChange(text: textView.text, type: .description, at: index)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "정보를 입력해주세요" {
            textView.text = ""
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       textField.text = ""
       return true
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let index = index!
        if textField == LocationName {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            delegate?.textViewDidChange(text: newText, type: .locationName, at: index)
        }
        return true
    }
}

extension DayLogTextCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // return the size of item
            return CGSize(width:148, height: 148)
        }
}

extension DayLogTextCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: DayTagCell.self)
        
        //셀의 인스턴스
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DayTagCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        guard let location = cell.location else {
            return cell
        }
        location.kf.setImage(with: data[indexPath.item])
        return cell
    }
    
    
}

extension DayLogTextCell {
    func Review (locationId : Int, keyword : [String], completion : @escaping () -> Void) {
        UserService.shared.Review(token: token, locationId: locationId, keyword: keyword) {
                response in
            switch response {
                case .success(let data) :
                    guard let data = data as? staticResponse else {return}
                    self.st = data.data!
                    completion()
                case .requsetErr(let err) :
                    print(err)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
            }
        }
    }
}


