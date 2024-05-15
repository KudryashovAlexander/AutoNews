//
//  Endpoint.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import Foundation

enum Endpoint {
    case news(page: Int, count: Int)
    
    static var baseURL: URL {
        URL(string:"https://webapi.autodoc.ru/api/news/")!
    }
    
    var url: URL? {
        switch self {
        case .news(let page, let count):
            return URL(string: "\(page)" + "/" + "\(count)", relativeTo: Endpoint.baseURL)
        }
    }
}
