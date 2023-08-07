//
//  Sercive.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/12.
//

import Foundation
import Alamofire
import Photos
import UIKit

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    func singUp(email: String, nickName: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.signUpURL
        
        print(url)
        
        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body : Parameters = [
            "email" : email,
            "nickName" : nickName,
            "password" : password
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                let networkResult = self.judgeStatus(by : statusCode, value, types : "Signup")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.loginURL
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body : Parameters = [
            "email" : email,
            "password" : password]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Login")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func delete(id : Int, token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.deleteURL + "/" + String(id)
        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Delete")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func travel(token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.travelURL
        
        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Travel")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func PhotoSave(travelId: Int, token: String, img: UIImage, dateTime: String, log: Double, lat: Double, city: String, fullAddress : String, completion: @escaping (NetworkResult<Any>) -> Void) {
            let url = APIConstants.PhotoSaveURL + String(travelId)
            
            // Prepare HTTPHeaders
            let headers: HTTPHeaders = [
                "Authorization": token,
            ]
            
            // Convert image to Data
            guard let imageData = img.jpegData(compressionQuality: 0.5) else { return }
            
            // Alamofire request
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "img", fileName: "image.jpg", mimeType: "image/jpg")
                multipartFormData.append(dateTime.data(using: .utf8)!, withName: "dateTime", mimeType: "application/json")
                multipartFormData.append("\(log)".data(using: .utf8)!, withName: "log", mimeType: "application/json")
                multipartFormData.append("\(lat)".data(using: .utf8)!, withName: "lat", mimeType: "application/json")
                multipartFormData.append("\(city)".data(using: .utf8)!, withName: "city", mimeType: "application/json")
                multipartFormData.append("\(fullAddress)".data(using: .utf8)!, withName: "fullAddress", mimeType: "application/json")
            }, to: url, headers: headers).response { response in
                switch response.result {
                    case .success:
                        guard let statusCode = response.response?.statusCode else { return }
                        guard let data = response.data else { return }
                        let networkResult = self.judgeStatus(by: statusCode, data, types: "PhotoSave")
                        completion(networkResult)
                    case .failure:
                        completion(.networkFail)
                }
            }
        }

    
    func calculate (token : String, id : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.calculateURL + String(id)

        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    print(statusCode)
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Calculate")
                    completion(networkResult)
                case .failure(let error) :
                    print("Error: \(error.localizedDescription)")
                    completion(.networkFail)
            }
        }
    }
    
    func test (token : String, id : Int, log: Double, lat: Double, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(lat) + "," + String(log) + APIConstants.GoogleKey

        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "test")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func userInfo ( id : Int, token:String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.uerInfoURL + String(id)
        //HTTP Header 요청 헤더
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "UserInfo")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func travelName ( id : Int, token:String, travelId : Int, title : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.travelNameURL + String(travelId)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let body : Parameters = ["title" : title]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .patch,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "TravelName")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func locationInfo ( locationId : Int, token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.locationInfoURL + String(locationId)
        
        print(url)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        //Request 생성
        //통신 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        //request 시작, responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in//데이터 통신 결과 저장
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "LocationInfo")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func locationName ( locationId : Int, token:String, title : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.changeLocationNameURL + String(locationId)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let body : Parameters = ["name" : title]
        
        let dataRequest = AF.request(
            url,
            method: .patch,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "LocationName")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func locationDiscription ( locationId : Int, token : String, description : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.changeDescriptionURL + String(locationId)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let body : Parameters = ["description" : description]
        
        let dataRequest = AF.request(
            url,
            method: .patch,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Description")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func travelInfo ( travelId : Int, token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.travelInfoURL + String(travelId)
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "TravelInfo")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func mapInfo ( travelId : Int, token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.MapInfoURL + String(travelId)
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "MapInfo")
                    completion(networkResult)
                case .failure :
                print(response)
                    completion(.networkFail)
            }
        }
    }
    
    func TravelAPI ( token : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.travelAPI
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "TravelAPI")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func Theme ( token : String, travelId : Int, theme : [String], completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.themeURL + String(travelId)
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let body : Parameters = [
            "theme" : theme
        ]
        
        let dataRequest = AF.request(
            url,
            method: .patch,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ThemeAPI")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func makeArticle ( token : String, travelId : Int, title : String, summary : String, locationContent : [String], budget : Int, member : String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.makeArticleURL + String(travelId)
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let body : Parameters = [
            "title" : title,
            "summary" : summary,
            "locationContent" : locationContent,
            "budget" : budget,
            "member" : member
        ]
        
        let dataRequest = AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "MakeArticle")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func ArticleFiltering (token : String, Filters : [String : String], thema : [String], completion: @escaping (NetworkResult<Any>) -> Void) {
        var url = APIConstants.ArticleFilteringURL
        if Filters.count > 0 {
            url += "?"
        }
        for filter in Filters {
            url += filter.key
            if let encodedValue = filter.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url += "=" + encodedValue
            } else {
                print("Invalid filter value: \(filter.value)")
            }
            url += "&"
        }
        
        for them in thema {
            url += "thema"
            if let encodedValue = them.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url += "=" + encodedValue
            } else {
                print("Invalid filter value: \(them)")
            }
            url += "&"
        }
        
        if Filters.count > 0 {
            url = String(url.dropLast())
        }
        print(url)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleFiltering")
                    completion(networkResult)
                case .failure :
                    print(response)
                    completion(.networkFail)
            }
        }
    }
    
    func ArticleInfo ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.ArticleInfo + String(articleId)
        print(url)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleInfo")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func ArticleReport ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.ArticleReport + String(articleId)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleReport")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func like ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.likeURL + String(articleId)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleReport")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func likeCancle ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.likeURL + String(articleId)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleReport")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func bookmarkCancle ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.bookmarkURL + String(articleId)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleReport")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func bookmark ( token : String, articleId : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.bookmarkURL + String(articleId)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "ArticleReport")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func BookMarkedArticle(token : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.ArticleBookMarkedURL
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "BookMarkedArticle")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func TourBookMark(token : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.TourBookmaredkURL
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "TourBookMarked")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func makeTourBookMark(token : String, tourID : Int, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.TourBookmarkURL + String(tourID)
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Description")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func TourBookMarkCancle(token : String, tourId : Int, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.TourBookmarkURL + String(tourId)
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .delete,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Description")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func Tour(token : String, page : Int, tag : [String], completion : @escaping (NetworkResult<Any>) -> Void) {
        var url = APIConstants.TourURL + "page=" + String(page) + "&size=30"
        
        if tag.count > 0 {
                for t in tag {
                    if let encodedTag = t.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        url += "&keyword="
                        url += encodedTag
                    }
                }
            }
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Tour")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func TourInfo(token : String, contentId : Int, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.TourContentURL + String(contentId)
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "TourContent")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func PhotoTag(token : String, tag : [String], page : Int, completion : @escaping (NetworkResult<Any>) -> Void) {
        var url = APIConstants.PhotoTagURL + "page=" + String(page) + "&size=30"
        
        if tag.count > 0 {
                for t in tag {
                    if let encodedTag = t.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        url += "&keyword="
                        url += encodedTag
                    }
                }
            }
        
        print(url)
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "PhotoTag")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func PhotoInfo(token : String, photoId : Int, completion : @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.PhotoInfo + String(photoId)
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "PhotoInfo")
                    completion(networkResult)
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func Review(token : String, locationId : Int, keyword : [String], completion : @escaping (NetworkResult<Any>) -> Void) {
        var url = APIConstants.ReviewURL
        
        if keyword.count > 0 {
            url += "?"
            for key in keyword {
                if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    url += "keyword="
                    url += encodedKey
                    url += "&"
                }
            }
            url = String(url.dropLast())
        }
        
        print(url)
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : token
        ]
        let dataRequest = AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        dataRequest.responseData{
            response in
            switch response.result {
                case .success :
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    
                    let networkResult = self.judgeStatus(by : statusCode, value, types: "Review")
                    completion(networkResult)
                case .failure(let error):
                    print("Network request error: \(error)")
                    completion(.networkFail)
            }
        }
    }
    
//MARK: - judgeStatus
    private func judgeStatus(by statusCode : Int, _ data:Data, types : String) -> NetworkResult<Any> {
        switch statusCode {
            case ..<300 :
                print(statusCode)
                let decoder = JSONDecoder()
                do {
                    let errorMessage = try decoder.decode(FailResponse.self, from: data)
                    print(errorMessage.message)
                } catch {
                    print("Error decoding error message")
                }
                return isVaildData(data: data, types : types)
            case 400..<500 :
                print(statusCode)
                print(types)
                let decoder = JSONDecoder()
                do {
                    let errorMessage = try decoder.decode(FailResponse.self, from: data)
                    print(errorMessage.message)
                } catch {
                    print("Error decoding error message: \(error)")
                }
                return .pathErr
            case 500..<600 :
                print(statusCode)
                print(types)
                // Decode the error message
                let decoder = JSONDecoder()
                do {
                    let errorMessage = try decoder.decode(FailResponse.self, from: data)
                    print(errorMessage.message)
                } catch {
                    print("Error decoding error message: \(error)")
                }
                return .serverErr
            default :
                print(statusCode)
                let decoder = JSONDecoder()
                do {
                    let errorMessage = try decoder.decode(FailResponse.self, from: data)
                    print(errorMessage.message)
                } catch {
                    print("Error decoding error message: \(error)")
                }
                return .networkFail
        }
    }
    
    
//MARK: - isVailData
    private func isVaildData(data : Data ,types : String) ->NetworkResult<Any> {
        let decoder = JSONDecoder()//서버에서 받은 데이터를 codable로 선택
        var decodeData : Any?
        //데이터가 변환이 되게끔 response 구조체로 데이터를 변환해서넣고 해당 데이터를 networkresult success 파라미터로 전달
        if types == "Signup" {
            guard let decoded = try? decoder.decode(SignupResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "Login" {
            guard let decoded = try? decoder.decode(LoginResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "Delete" {
            guard let decoded = try? decoder.decode(DeleteResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "Travel" {
            guard let decoded = try? decoder.decode(TravelResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "PhotoSave" {
            guard let decoded = try? decoder.decode(PhotoSaveResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "Calculate" {
            guard let decoded = try? decoder.decode(CalculateResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "test" {
            guard let decoded = try? decoder.decode(testmodel.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "UserInfo" {
            guard let decoded = try? decoder.decode(UserInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "TravelName" {
            guard let decoded = try? decoder.decode(TravelNameResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "LocationInfo" {
            guard let decoded = try? decoder.decode(LocationInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        else if types == "LocationName" || types == "Description" || types == "ArticleReport" || types == "Review"{
            guard let decoded = try? decoder.decode(staticResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "TravelInfo" {
            guard let decoded = try? decoder.decode(TravelInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "MapInfo" {
            guard let decoded = try? decoder.decode(MapInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "TravelAPI" {
            guard let decoded = try? decoder.decode(TravelAPIResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "ThemeAPI" {
            guard let decoded = try? decoder.decode(staticResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "MakeArticle" {
            guard let decoded = try? decoder.decode(staticResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "ArticleFiltering" {
            guard let decoded = try? decoder.decode(ArticlesFilteringResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "ArticleInfo" {
            guard let decoded = try? decoder.decode(ArticleInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "BookMarkedArticle" {
            guard let decoded = try? decoder.decode(BookMarkedArticleResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "TourBookMarked" {
            guard let decoded = try? decoder.decode(TourBookMarkResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "Tour" {
            guard let decoded = try? decoder.decode(TourResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "TourContent" {
            guard let decoded = try? decoder.decode(TourInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        else if types == "PhotoTag" {
            guard let decoded = try? decoder.decode(PhotoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        else if types == "PhotoInfo" {
            guard let decoded = try? decoder.decode(PhotoInfoResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        
        else {
            guard let decoded = try? decoder.decode(FailResponse.self, from: data)
            else {return .pathErr}
            decodeData = decoded
        }
        
        
        if let decodeData = decodeData {
            return .success(decodeData)
        }
        else {
            return .pathErr
        }
    }
    
}
