//
//  ArticleInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/01.
//

import Foundation

struct ArticleInfoResponse :Codable{
    let status : Bool
    let message : String
    var data : ArticleInfoData?
}

struct ArticleInfoData : Codable{
    let articleId : Int
    let nickname : String
    let title : String?
    let summary : String?
    let days : [ArticleDayData]?
    let budget : Int
    let member : String?
    let theme : [String]
    var likes : Int
    let likeStatus : Bool
    var bookmarks : Int
    let bookmarkStatus : Bool
}

struct ArticleDayData : Codable {
    let dayID : Int
    let sequence : Int
    let date : String
    let locations : [ArticleLocation]?
}

struct ArticleLocation : Codable {
    let locationId : Int
    let name : String?
    let degree : String?
    let city : String?
    let content : String?
    let photoIds : [Int]
    let photoUrls : [String]
    let coordinate : CordinateData
}

