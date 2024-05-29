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

struct GetAlbumsRequest: APIRequest {
    typealias ResponseType = [Album]
    
    var endpoint: String = "/albums"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL?
    
    var parameters: [String : String] = [String:String]()
}

struct GetPhotosRequest: APIRequest {
    typealias ResponseType = [Photo]
    
    var endpoint: String = "/photos"
    
    var method: HttpMethod = .GET
    
    var headers: [String : String] = ["Content-Type": "application/json"]
    
    var baseURL: URL?
    
    var parameters: [String : String] = [String:String]()
}


protocol APIClient {
    var defaultBaseURL: URL { get }
    
    func executeWithCompletion<T: APIRequest>(_ request: T, completion: @escaping (T.ResponseType?, Error?) -> Void)
}

class APIClientImpl: APIClient {
    let defaultBaseURL: URL
    
    init(defaultBaseURL: URL) {
        self.defaultBaseURL = defaultBaseURL
    }
    
    
    private func makeURL(with request: any APIRequest) -> URL {
        var urlComponent = URLComponents()
        if let baseURL = request.baseURL {
            urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        } else {
            urlComponent = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)!
        }
        urlComponent.path = request.endpoint
        
        var queryItems: [URLQueryItem] = []
        for param in request.parameters {
            queryItems.append(
                URLQueryItem(name: param.key, value: param.value)
            )
        }
        urlComponent.queryItems = queryItems
        
        return urlComponent.url!
    }
    
    private func makeURLRequest(with request: any APIRequest) -> URLRequest {
        let url = makeURL(with: request)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func executeWithCompletion<T>(_ request: T, completion: @escaping (T.ResponseType?, (any Error)?) -> Void) where T: APIRequest {
        let urlRequest = makeURLRequest(with: request)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200,
                  httpResponse.statusCode < 300,
                  let data = data,
                  let json = try? JSONDecoder().decode(T.ResponseType.self, from: data)
            else {
                completion(nil, URLError(.badServerResponse))
                return
            }
            completion(json, nil)
        }.resume()
    }
}
