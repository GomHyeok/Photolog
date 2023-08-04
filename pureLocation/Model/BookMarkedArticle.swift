//
//  BookMarkedArticle.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/03.
//

import Foundation

struct BookMarkedArticleResponse : Codable{
    let status : Bool
    let message : String
    let data : [BookMarkedArticleData]?
}

struct BookMarkedArticleData : Codable{
    let id : Int
    let nickname : String?
    let city : String
    let title : String?
    let startDate : String
    let endDate : String
    let thumbnail : String
    let photoCnt : Int
    let likes : Int
    let bookmarks : Int
}
