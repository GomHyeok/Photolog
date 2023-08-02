//
//  APIConstants.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import Foundation

struct APIConstants {
    //MARK: - Base URL
    static let baseURL = "http://13.209.89.186:8080"
    
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
    
    //UserInfoURL
    static let uerInfoURL = baseURL + "/api/user/"
    
    //Google Key
    static let GoogleKey = "&key=AIzaSyDstkkUqoCFutr1fsmHm8rogfNi96wqQiU"
    
    //TravelNameURL
    static let travelNameURL = baseURL + "/api/travel/title/"
    
    //LocationInfoURL
    static let locationInfoURL = baseURL + "/api/location/"
    
    //ChangeLocationNameURL
    static let changeLocationNameURL = baseURL + "/api/location/name/"
    
    //ChangeDescriptionURL
    static let changeDescriptionURL = baseURL + "/api/location/description/"
    
    //TravelInfoURL
    static let travelInfoURL = baseURL + "/api/travel/textSummary/"
    
    //MapInfoURL
    static let MapInfoURL = baseURL + "/api/travel/mapSummary/"
    
    //FindPassword
    
    //Tavel
    static let travelAPI = baseURL + "/api/travel"
    
    //ThemeURL
    static let themeURL = baseURL + "/api/travel/theme/"
    
    //makeArticle
    static let makeArticleURL = baseURL + "/api/articles/"
    
    //articleFiltering
    static let ArticleFilteringURL = baseURL + "/api/articles/filtering"
    
    //articleInfo
    static let ArticleInfo = baseURL + "/api/articles/"
}
