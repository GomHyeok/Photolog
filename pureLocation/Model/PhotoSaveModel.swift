//
//  PhotoSaveModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/14.
//

import Foundation

struct PhotoSaveResponse : Codable {
    let status : Bool
    let message : String
    let data : Int?
}
