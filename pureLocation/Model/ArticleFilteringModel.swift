//
//  ArticleFilteringModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/30.
//

import Foundation

struct ArticlesFilteringResponse : Codable {
    let status : Bool
    let message : String
    let data : [ArticlesFilteringData]?
}

struct ArticlesFilteringData : Codable {
    let id : Int
    let nickname : String
    let degree : String //도
    let city : String
    let title : String?
    let startDate : String
    let endDate : String
    let thumbnail : String
    let photoCnt : Int
    let likes : Int
    let bookmarks : Int
}
