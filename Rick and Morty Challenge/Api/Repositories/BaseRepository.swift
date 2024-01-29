//
//  BaseRepository.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 28/01/2024.
//

import Foundation
import Alamofire


open class BaseRepository {
    
    let baseUrl = "https://rickandmortyapi.com/api"
    
    let apiHeaders: HTTPHeaders = HTTPHeaders([
        "Content-Type": "application/json",
    ])
    
    let paramPage = "page"
    
}


/**
 We wanna make the sintax a bit prettier when making API calls using Alamofire.
 */
extension BaseRepository {
    
    public func getRequest(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> DataRequest
    {
        return AF.request(
            baseUrl + url,
            method: method,
            parameters: parameters,
            headers: headers ?? apiHeaders,
            interceptor: nil
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
    }
    
    public func postRequest(
        _ url: String,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        includeBaseUrl: Bool = true
    ) -> DataRequest
    {
        let endpoint = (includeBaseUrl)
            ? baseUrl + url
            : url
        
        return AF.request(
            endpoint,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers ?? apiHeaders,
            interceptor: nil
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
    }
    
    public func putRequest(
        _ url: String,
        method: HTTPMethod = .put,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        includeBaseUrl: Bool = true
    ) -> DataRequest
    {
        let endpoint = (includeBaseUrl)
            ? baseUrl + url
            : url
        
        return AF.request(
            endpoint,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers ?? apiHeaders,
            interceptor: nil
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
    }
    
}
