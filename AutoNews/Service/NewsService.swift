//
//  NewsService.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import Combine
import Foundation

protocol NewsServiceProtocol {
    var news: PassthroughSubject<NewsAnswer, Never> { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func fetchNews(page: Int, count: Int)
}

actor NewsService: NewsServiceProtocol {
    nonisolated private let networkClient: NetworkClient
    nonisolated let news: PassthroughSubject<NewsAnswer, Never>
    nonisolated let isLoading: CurrentValueSubject<Bool, Never>
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.news = PassthroughSubject()
        self.isLoading = CurrentValueSubject(false)
    }
    
    nonisolated func fetchNews(page: Int, count: Int = 10) {
        self.isLoading.send(true)
        Task { await getNews(page: page, count: count) }
    }
    
    private func getNews(page: Int, count: Int) async {
        do {
            let newsAnswer: NewsAnswer = try await networkClient.request(endPoint: .news(page: page, count: count))
            self.news.send(newsAnswer)
            self.isLoading.send(false)
        } catch let error {
            self.isLoading.send(false)
            if let appError = error as? AppError {
                ErrorHandler.handle(error: appError)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }
}

