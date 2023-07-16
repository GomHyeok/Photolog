//
//  testmodel.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/14.
//

import Foundation

struct testmodel: Codable {
    let results: [Result]
    let status: String
    
    struct Result: Codable {
        let addressComponents: [AddressComponent]
        let formattedAddress: String
        let geometry: Geometry
        let placeId: String
        let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case addressComponents = "address_components"
            case formattedAddress = "formatted_address"
            case geometry
            case placeId = "place_id"
            case types
        }
        
        struct AddressComponent: Codable {
            let longName: String
            let shortName: String
            let types: [String]
            
            enum CodingKeys: String, CodingKey {
                case longName = "long_name"
                case shortName = "short_name"
                case types
            }
        }
        
        struct Geometry: Codable {
            let location: Location
            let locationType: String
            let viewport: Viewport
            
            enum CodingKeys: String, CodingKey {
                case location
                case locationType = "location_type"
                case viewport
            }
            
            struct Location: Codable {
                let lat: Double
                let lng: Double
            }
            
            struct Viewport: Codable {
                let northeast: Location
                let southwest: Location
            }
        }
    }
}
