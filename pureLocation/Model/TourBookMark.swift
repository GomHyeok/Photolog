//
//  TourBookMark.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/04.
//

import Foundation

struct TourBookMarkResponse : Codable {
    let status : Bool
    let message : String
    let data : [TourBookMarkData]?
}

struct TourBookMarkData : Codable {
    let tourId : Int
    let firstImage : String?
}
