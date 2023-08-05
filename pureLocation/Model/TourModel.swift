import Foundation

struct TourResponse : Codable {
    let status : Bool
    let message : String
    let data : TourData?
}

struct TourData : Codable {
    let content : [contentData]?
    let pageable : pageData?
    let totalPages : Int
    let totalElements : Int
    let last : Bool
    let size : Int
    let number : Int
    let sort : sortData?
    let numberOfElements : Int
    let first : Bool
    let empty : Bool
}

struct contentData : Codable {
    let id : Int
    let cat1 : String
    let cat2 : String
    let cat3 : String
    let contentId: Int
    let firstimage : String
    let title : String
    let bookmarkCount : Int?
}

struct pageData : Codable{
    let sort : sortData?
    let offset : Int
    let pageNumber : Int
    let pageSize : Int
    let paged : Bool
    let unpaged : Bool
}

struct sortData : Codable {
    let empty : Bool
    let sorted : Bool
    let unsorted : Bool
}
