//
//  NetworkClient.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func request<T:Decodable>(endPoint: Endpoint,
                              httpMethod: HttpMethod = .get) async throws -> T {
        var urlRequest = URLRequest(url: endPoint.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let (data, response) = try await session.data(for: urlRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
        switch statusCode {
        case 200..<300:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AppError.parsingError
            }
        default:
            do {
                let errorAnswer = try decoder.decode(NetworkErrorDescriptionModel.self, from: data)
                throw AppError.customError(errorAnswer.message ?? "")
            } catch {
                throw AppError.statucCodeError(code: statusCode)
            }
        }
    }
}
