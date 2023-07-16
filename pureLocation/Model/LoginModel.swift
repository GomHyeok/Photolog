//
//  LoginModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import Foundation

struct LoginResponse : Codable {
    let status : Bool
    let message : String
    let data : LoginData?
}
struct LoginData : Codable {
    let userId : Int
    let token : String
}
