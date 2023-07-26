//
//  TravelAPIModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/25.
//

import Foundation

struct TravelAPIResponse : Codable {
    let status : Bool
    let message :String
    let data : [TravelAPIData]
}

struct TravelAPIData : Codable{
    let travelId : Int
    let city : String
    let title : String?
    let startDate : String
    let endDate : String
    let thumbnail : String
    let photoCnt : Int
}
