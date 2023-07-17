//
//  TravelNameModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import Foundation

struct TravelNameResponse : Codable {
    let status : Bool
    let message : String
    let data : String?
}
