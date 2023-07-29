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
