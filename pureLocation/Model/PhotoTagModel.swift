//
//  PhotoTagModel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/05.
//

import Foundation

struct PhotoResponse: Codable {
    let status: Bool
    let message: String
    let data: DataClass
}

struct DataClass: Codable {
    let totalPages, totalElements, size: Int
    let content: [Content]
    let number: Int
    let sort: Sort
    let pageable: Pageable
    let numberOfElements: Int
    let first, last, empty: Bool
}

struct Content: Codable {
    let photoId: Int
    let photoUrl: String
}

struct Pageable: Codable {
    let offset, pageNumber, pageSize: Int
    let sort: Sort
    let paged, unpaged: Bool
}

struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
