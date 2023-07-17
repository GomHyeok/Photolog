//
//  CalculateModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/14.
//

import Foundation

struct CalculateResponse : Codable{
    let status : Bool
    let message : String
    let data : CalculateData?
}

struct CalculateData : Codable {
    let night : Int
    let day : Int
    let startDate : String
    let endDate : String
    let locationNum : Int
    let photoNum : Int
    let locationList : [Int]
}
