//
//  TourInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import Foundation

struct TourInfoResponse: Codable {
    let status: Bool
    let message: String
    let data: DataDetails?
}

struct DataDetails: Codable {
    let imageUrl: String?
    let cat1: String
    let cat2: String
    let cat3: String
    let title: String
    let bookmarkCount: Int?
    let address: String
    let content: String
    let infoCall: String
    let restDate: String?
    let useTime: String?
}
