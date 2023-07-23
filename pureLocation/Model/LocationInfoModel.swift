//
//  LocationInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/18.
//

import Foundation

struct LocationInfoResponse :Codable {
    let status : Bool
    let message : String
    let data : LocationInfoData?
}

struct LocationInfoData :Codable {
    let locationId : Int
    let sequence : Int
    let date : String
    let photoIdList : [Int]
    let urlList : [String]
    let fullAddress : String
    let description : String?
    let name : String?
}
