//
//  APIClient.swift
//  VariousAPIList
//
//  Created by naoya on 2024/05/15.
//

import Foundation

enum HttpMethod: String {
    case GET
}

protocol APIRequest {
    associatedtype ResponseType: Decodable

    var endpoint: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var baseURL: URL? { get }
    var parameters: [String: String] { get }
    var url: URL {get}
}

struct GetAlbumsRequest: APIRequest {
    typealias ResponseType = [Album]
    
    var endpoint: String = "/albums"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL? = URL(string: "https://jsonplaceholder.typicode.com")
    
    var parameters: [String : String] = ["":""]
    
    var url: URL {
        var urlComponent = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)!
        urlComponent.path = endpoint

        return urlComponent.url!
    }
}

struct GetPhotosRequest: APIRequest {
    typealias ResponseType = [Photo]
    
    var endpoint: String = "/photos"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL? = URL(string: "https://jsonplaceholder.typicode.com")
    
    var parameters: [String : String] = ["":""]
    
    var url: URL {
        var urlComponent = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)!
        urlComponent.path = endpoint
        urlComponent.queryItems = [URLQueryItem(name: "albumId", value: "1")]

        return urlComponent.url!
    }
}

protocol APIClient {
    func executeWithCompletion<T: APIRequest>(_ request: T, completion: @escaping (T.ResponseType?, Error?) -> Void) async throws -> T.ResponseType
}

class APIClientImpl: APIClient {
    
    func executeWithCompletion<T>(_ request: T, completion: @escaping (T.ResponseType?, (any Error)?) -> Void) async throws -> T.ResponseType where T: APIRequest {
        let requestUrl = request.url
        var getRequest = URLRequest(url: requestUrl)
        if let contentType = request.headers["Content-Type"] {
            getRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        let (data, _) = try! await URLSession.shared.data(for: getRequest)
        let result = try! JSONDecoder().decode(T.ResponseType.self, from: data)
        completion(result,nil)
        return result
    }
}
