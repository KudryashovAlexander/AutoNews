//
//  MainScreenViewModelProtocol.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import Combine
import Foundation

protocol MainScreenViewModelProtocol: AnyObject {
    
    var news: CurrentValueSubject<[NewsUIModel],Never> { get }
    var viewState: CurrentValueSubject<ViewState,Never> { get }
    var currentNews: PassthroughSubject<NewsUIModel,Never> { get }
    
    func getNewsCount() -> Int
    func getNews(_ index: Int) -> NewsUIModel
    func loadNews()
    func addNews()
    func presentFullNews(index: Int)
}
