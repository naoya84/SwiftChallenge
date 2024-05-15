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
}

extension APIRequest {
    var url: URL {
        var urlComponent = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)!
        urlComponent.path = endpoint

        return urlComponent.url!
    }
}

struct GetAlbumsRequest: APIRequest {
    typealias ResponseType = [Album]
    
    var endpoint: String = "/albums"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL? = URL(string: "https://jsonplaceholder.typicode.com")
    
    var parameters: [String : String] = ["":""]
    
}

struct GetPhotosRequest: APIRequest {
    typealias ResponseType = [Photo]
    
    var endpoint: String = "/photos?albumId=1"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL? = URL(string: "https://jsonplaceholder.typicode.com")
    
    var parameters: [String : String] = ["":""]
}

protocol APIClient {
    func executeWithCompletion<T: APIRequest>(_ request: T, completion: @escaping (T.ResponseType?, Error?) -> Void) async throws -> T.ResponseType
}

class APIClientImpl: APIClient {
    
    func executeWithCompletion<T>(_ request: T, completion: @escaping (T.ResponseType?, (any Error)?) -> Void) async throws -> T.ResponseType where T: APIRequest {
        // TODO: ここを実装する
        let requestUrl = request.url
        let getRequest = URLRequest(url: requestUrl)

        let (data, error) = try await URLSession.shared.data(for: getRequest)
        let result = try! JSONDecoder().decode(T.ResponseType.self, from: data)
        completion(result,nil)
        return result
    }
}
