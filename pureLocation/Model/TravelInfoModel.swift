struct TravelInfoResponse : Codable {
    let status: Bool
    let message: String
    let data: TravelInfoData?
}

struct TravelInfoData : Codable{
    let id: Int
    let title: String
    let startDate: String
    let endDate: String
    let totalDate: Int
    let days: [DayData]
}

struct DayData : Codable {
    let id: Int
    let sequence: Int
    let date: String
    let locations: [LocationData]
}

struct LocationData : Codable {
    let id: Int
    let name: String?
    let description: String?
    let photoUrls: [String]
}
