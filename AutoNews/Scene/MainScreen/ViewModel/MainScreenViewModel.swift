//
//  MainScreenViewModel.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//
import Combine
import Foundation

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    // MARK: - Public properties
    private(set) var news: CurrentValueSubject<[NewsUIModel], Never>
    private(set) var viewState: CurrentValueSubject<ViewState,Never>
    private(set) var currentNews: PassthroughSubject<NewsUIModel, Never>
    
    // MARK: - Private properties
    //service
    
    // MARK: - Lifecicle
    init() {
        self.news = CurrentValueSubject(NewsUIModel.examples)
        self.viewState = CurrentValueSubject(.empty)
        self.currentNews = PassthroughSubject()
    }
    
    // MARK: - Public methods
    func loadNews() {
        viewState.send(.loading)
        //
    }
    
    func addNews() {
        //
    }
    
    func presentFullNews(index: Int) {
        let model = news.value[index]
        currentNews.send(model)
    }
    
    func getNewsCount() -> Int {
        news.value.count
    }
    
    func getNews(_ index: Int) -> NewsUIModel {
        news.value[index]
    }
    
    
    
    // MARK: - Private methods
    //binding
    
}
