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
        static var key=""
        static var firstName:String?=nil
        static var lastName:String?=nil
    }
    
    enum ErrorType:String{
        case NetworkError="NetworkError"
        case CredentialsError="CredentialsError"
    }
    
    class func getStudentLocations(completionHandler:@escaping ([StudentLocation]?,Error?)->Void){
        //number of fetched locations is 150 not 100 to handle the skipped nil valued locations
        let url=URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!
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
                }
                catch{
                    completionHandler(nil,error)
                }
            
        }
        task.resume()
    }
    
    class func postStudentLocation(location:StudentLocation,completionHandler:@escaping(Bool,Error?)->Void){
        let url=URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        var request=URLRequest(url: url)
        request.httpMethod="POST"
        request.addValue(Auth.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Auth.restApiKey, forHTTPHeaderField: "X-Parse-Rest-API-Key")
        do{
            let json=try JSONEncoder().encode(location)
            request.httpBody=json
        }
        catch{
            completionHandler(false,error)
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completionHandler(false,error)
                return
            }
            do{
                let response=try JSONDecoder().decode(PostLocationResponse.self, from: data!)
                if(response.objectId == nil){
                    completionHandler(false,error)
                }
                else{
                    completionHandler(true,nil)
                }
            }
            catch{
                completionHandler(false,error)
            }
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
            do{
                let actualResponse=data!.subdata(in: 5..<data!.count)
                let decoder=JSONDecoder()
                let respone=try decoder.decode(PostSessionResponse.self, from: actualResponse)
                Auth.key=respone.account.key!
                getUserDetails() //just to get first and last names of the user
                completionHandler(true,nil,nil)
            }
            catch{
                completionHandler(false,error,ErrorType.CredentialsError) //credentials error
            }
        }
        task.resume()
    }
    
    class func getUserDetails(){
        //no need to check for success
        let url=URL(string: "https://onthemap-api.udacity.com/v1/users/\(Auth.key)")!
        let request=URLRequest(url: url)
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                return
            }
            do{
                let data=try JSONDecoder().decode(User.self, from: data!.subdata(in: 5..<data!.count))
                Auth.firstName=data.firstName
                Auth.lastName=data.lastName
            }
            catch{
            }
        }
        task.resume()
    }
    
    class func deleteSession(){
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
                return
            }
        }
        task.resume()
    }
    
    class func getAccountLocation(completionHandler:@escaping(Bool?,Error?)->Void){
        //each account location has a unique key equals to the account key
        let url=URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22lastName%22%3A%22\(Auth.lastName ?? "")%22%7D")!
        var request=URLRequest(url: url)
        request.addValue(Auth.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Auth.restApiKey, forHTTPHeaderField: "X-Parse-Rest-API-Key")
        let task=URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completionHandler(nil,error) //error occured during the request
                return
            }
            do{
                let location=try JSONDecoder().decode(StudentLocation.self, from: data!)
                if location.uniqueKey==Auth.key{
                    completionHandler(true,nil) //location exists for this account
                }
                else{
                    completionHandler(false,nil)
                }
            }
            catch{
                completionHandler(nil,error) //there's no location for that account
            }
        }
        task.resume()
    }
}

