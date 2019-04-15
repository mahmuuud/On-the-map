//
//  Client.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/10/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation


class Client{
    struct Auth {
         static let  restApiKey="QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
         static let  parseApplicationId="QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    enum ErrorType:String{
        case NetworkError="NetworkError"
        case CredentialsError="CredentialsError"
    }
    
    class func getStudentLocations(completionHandler:@escaping ([StudentLocation]?,Error?)->Void){
        //number of fetched locations is 150 not 100 to handle the skipped nil valued locations
        let url=URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100?order=-updatedAt")!
        var request=URLRequest(url: url)
        request.addValue(Auth.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Auth.restApiKey, forHTTPHeaderField: "X-Parse-Rest-API-Key")
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completionHandler(nil,error)
                return
            }
            do{
                let results = try JSONDecoder().decode(GetLocationsResponse.self, from: data!)
                completionHandler(results.results,nil)
                print(results.results[0])
            }
            catch{
                completionHandler(nil,error)
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(){
        let url=URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        request.addValue(Auth.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Auth.restApiKey, forHTTPHeaderField: "X-Parse-Rest-API-Key")
        let location=StudentLocation.init(objectId: nil, uniqueKey: "3341", firstName: "hussam", lastName: "doe", mapString: "cph", mediaUrl: nil, latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil)
        let json=try! JSONEncoder().encode(location)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody=json
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                return
            }
            let response=try! JSONDecoder().decode(PostLocationResponse.self, from: data!)
            print(response)
        }
        task.resume()
    }
    
    class func postSession(username:String,password:String, completionHandler:@escaping (Bool,Error?,ErrorType?)->Void){
        let url=URL(string: "https://onthemap-api.udacity.com/v1/session")!
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let user=PostSessionRequest.init(udacity: ["username":username,"password":password], username: username, password: password)
        let userJson=try! JSONEncoder().encode(user)
        request.httpBody=userJson
        let task=URLSession.shared.dataTask(with: request) { (data, respnonse, error) in
            if let error=error{
                completionHandler(false,error,ErrorType.NetworkError) //network error
                return
            }
            print(String(data: data!.subdata(in: 5..<data!.count), encoding: .utf8)!)
            do{
                let actualResponse=data!.subdata(in: 5..<data!.count)
                let decoder=JSONDecoder()
                _=try decoder.decode(PostSessionResponse.self, from: actualResponse)
                completionHandler(true,nil,nil)
            }
            catch{
                completionHandler(false,error,ErrorType.CredentialsError) //credentials error
                print(error ,"FROM CLIENT.POSTSESSION")
            }
        }
        task.resume()
    }
    
    class func deleteSession(completionHandler:@escaping(Bool,Error?)->Void){
        let url=URL(string: "https://onthemap-api.udacity.com/v1/session")!
        var request=URLRequest(url: url)
        request.httpMethod="DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let cookieStorage=HTTPCookieStorage.shared
        var xsrfCookie:HTTPCookie?=nil
        for cookie in cookieStorage.cookies!{
            if cookie.name=="XSRF-TOKEN"{
                xsrfCookie=cookie
            }
        }
        if let xsrfCookie=xsrfCookie{
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completionHandler(false,error)
                return
            }
            print("COOKIEEEE VALUEEEEEE: \(xsrfCookie?.value ?? "no value")")
            let response=try! JSONDecoder().decode(DeleteSessionResponse.self, from: data!.subdata(in: 5..<data!.count))
            print(response)
        }
        task.resume()
    }
}

