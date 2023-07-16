//
//  APIConstants.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import Foundation

struct APIConstants {
    //MARK: - Base URL
    static let baseURL = "http://3.34.5.208:8080"
    
    //MARK: - Feature URL
    // Login URL
    static let loginURL = baseURL + "/api/user/login"
    
    //signUpURL
    static let signUpURL = baseURL + "/api/user/signup"
    
    //deleteURL
    static let deleteURL = baseURL + "/api/user/delete"
    
    //TravelURL
    static let travelURL = baseURL + "/api/travel/create"
    
    //PhotoSaveURL
    static let PhotoSaveURL = baseURL + "/api/photo/save/"

    //CalculateURL
    static let calculateURL = baseURL + "/api/travel/calculate/"
}
