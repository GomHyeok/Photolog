//
//  boolModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/08.
//

import Foundation


struct BoolResponse : Codable {
    let status : Bool
    let message : String
    let data : Bool?
}
