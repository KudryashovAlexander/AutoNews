//
//  NetworkClientProtocol.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import Combine
import Foundation

protocol NetworkClientProtocol {
    func request<T:Decodable>(endPoint: Endpoint, httpMethod: HttpMethod) async throws -> T
}
