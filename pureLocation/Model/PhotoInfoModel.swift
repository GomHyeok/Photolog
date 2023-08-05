//
//  PhotoInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import Foundation

struct PhotoInfoResponse: Codable {
    let status: Bool
    let message: String
    let data: ArticleData
}

struct ArticleData: Codable {
    let articleId: Int
    let photoUrl: String
    let articleTitle: String?
    let locationName: String?
    let locationContent: String?
}
