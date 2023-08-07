//
//  SwitchChildProtocol.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/27.
//

import Foundation

protocol ChildViewControllerDelegate : AnyObject {
    func switchTotaltToMap()
    func switchMaptoTotal()
}

protocol ChildDelegate : AnyObject {
    func tagToText(cnt : Int)
    func textToTag(cnt : Int)
}

protocol homeDelegate : AnyObject {
    func switchTotaltToMap(data : TravelAPIResponse?)
    func switchMaptoTotal()
    func switchToBoard()
    func switchToHome()
    func switchToMypage()
    func switchToTag()
    func switchToMap()
    func switchToSearch(tag : [String])
    func switchToSTag(tag : [String])
}

protocol DayLogTextCellDelegate: AnyObject {
    func didTapAIButton(in cell: DayLogTextCell)
    func didTapAIButtons(in cell : DayLogTextCell)
    func textViewDidChange(text: String, type: TextViewType, at index: Int)
}

protocol tagDelegate : AnyObject {
    func switchToMypage()
    func switchToTag()
    func switchToBoard()
}

protocol tagCollectDelegate : AnyObject {
    func switchToMypage()
    func switchToTag()
    func switchToBoard()
}
