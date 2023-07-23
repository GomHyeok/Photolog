//
//  MapInfoModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/21.
//

import Foundation

struct MapInfoResponse : Codable {
    let status : Bool
    let message : String
    let data : MapInfoData?
}

struct MapInfoData : Codable{
    let id : Int
    let title : String
    let startDate : String
    let endDate : String
    let totalDate : Int
    let days : [DaysData]
}

struct DaysData : Codable{
    let id : Int
    let sequence : Int
    let date : String
    let locations : [LocationsData]
}

struct LocationsData : Codable{
    let id : Int
    let name : String?
    let description : String?
    let photoUrl : String
    let coordinate : CordinateData?
}

struct CordinateData : Codable{
    let longitude : Double
    let latitude : Double
}
