//
//  MakeArticleModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/29.
//

import Foundation

struct MakeArticleResponse : Codable{
    let status : Bool
    let message : String
    let data : Int?
}
