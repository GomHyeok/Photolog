//
//  DeleteModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/13.
//

import Foundation

struct DeleteResponse : Codable {
    let status : Bool
    let message : String
    let data : DeletData?
}
struct DeletData : Codable {
    
}
