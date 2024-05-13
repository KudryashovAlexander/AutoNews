//
//  NewsNetModel.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import Foundation
// MARK: - NewsAnswer
struct NewsAnswer: Codable {
    let news: [NewsNetModel]
    let totalCount: Int
}

// MARK: - NewsNetModel
struct NewsNetModel: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
