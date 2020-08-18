import Foundation

public class Route<ResultType> {
    enum Error: Swift.Error {
        case invalidEndpoint(String)
        case badResponse(URLResponse?)
    }
    public enum Method: String { case get, post }

    let method: Method
    let baseURL: String
    let endpoint: String
    let params: [String: Any]
    let session: URLSession

    public init(baseURL: String = Portal.current.apiDomain,
         endpoint: String,
         method: Method = .get,
         params: [String: Any] = [:],
         session: URLSession = .shared) {
        self.method = method
        self.endpoint = endpoint
        self.params = params
        self.baseURL = baseURL
        self.session = session
    }
    
    func makeRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            throw Error.invalidEndpoint(endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if case .get = method {
            var urlComponents = URLComponents()
            urlComponents.scheme = url.scheme
            urlComponents.host = url.host
            urlComponents.path = url.path
            urlComponents.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            request.url = urlComponents.url
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
        }
        
        return request
    }
}

extension Route where ResultType: Decodable {

    @discardableResult
    public func result(completion: @escaping (Result<ResultType, Swift.Error>) -> ()) -> URLSessionTask? {
        do {
            let task = session.dataTask(with: try makeRequest()) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(Error.badResponse(response)))
                    return
                }
                do {
                    completion(.success(try JSONDecoder.apiResponseDecoder.decode(ResultType.self, from: data)))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            return task
        } catch {
            completion(.failure(error))
            return nil
        }
    }
}
