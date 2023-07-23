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
        //HTTP Header 요청 헤더
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
        print(url)
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
        
//        print(log)
//        print(lat)
//        print(city)
//        print(fullAddress)
//        print(dateTime)
        
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
                    print("success")
                    let networkResult = self.judgeStatus(by: statusCode, data, types: "PhotoSave")
                    completion(networkResult)
                case .failure:
                    completion(.networkFail)
            }
        }
    }
    
    func calculate (token : String, id : Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.calculateURL + String(id)
        print(url)
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
                case .failure :
                    completion(.networkFail)
            }
        }
    }
    
    func test (token : String, id : Int, log: Double, lat: Double, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(lat) + "," + String(log) + APIConstants.GoogleKey
        //print(url)
//        print(log)
//        print(lat)
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
        //print(url)
//        print(log)
//        print(lat)
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
                    completion(.networkFail)
            }
        }
    }
    
//MARK: - judgeStatus
    private func judgeStatus(by statusCode : Int, _ data:Data, types : String) -> NetworkResult<Any> {
        switch statusCode {
            case ..<300 :
                print(statusCode)
                return isVaildData(data: data, types : types)
            case 400..<500 :
                print(statusCode)
                print(types)
                return .pathErr
            case 500..<600 :
                print(statusCode)
                return .serverErr
            default : return .networkFail
        }
    }
    
    
//MARK: - isVailData
    private func isVaildData(data : Data ,types : String) ->NetworkResult<Any> {
        print(data)
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
        else if types == "LocationName" || types == "Description" {
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
        
        if let decodeData = decodeData {
            return .success(decodeData)
        }
        else {
            return .pathErr
        }
    }
    
}
