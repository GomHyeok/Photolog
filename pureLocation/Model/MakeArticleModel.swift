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
    let data : [MakeArticleData]?
}

struct MakeArticleData : Codable {
    let articleId : Int
    let travelId : Int?
    let title : String?
    let days : [MapDay]
}

struct MapDay :Codable {
    let dayID :Int
    let name : String
    
}
