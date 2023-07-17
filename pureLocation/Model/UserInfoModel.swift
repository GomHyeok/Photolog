//
//  UserInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import Foundation

struct UserInfoResponse : Codable{
    let status : Bool
    let message : String
    let data : UserInfoData?
}
struct UserInfoData : Codable {
    let email : String
    let nickName : String
}
