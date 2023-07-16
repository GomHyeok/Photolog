//
//  SingupModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import Foundation

struct SignupResponse : Codable {
    let status: Bool
    let message: String
    let data : Int?
}
