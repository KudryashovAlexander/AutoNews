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
    private(set) var oldCount: Int = 0
    private(set) var newCount: Int = 0
    
    // MARK: - Private properties
    private let service: NewsServiceProtocol
    private var currentPage: Int
    private var totalNews: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecicle
    init() {
        self.news = CurrentValueSubject([])
        self.viewState = CurrentValueSubject(.empty)
        self.service = NewsService(networkClient: NetworkClient())
        self.currentPage = 1
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        service.fetchNews(page: currentPage, count: 10)
    }
    
    func viewWillAppear() {
        binding()
    }
    
    func viewWillDisAppear() {
        bindingOff()
    }
    
    func addNews() {
        if !news.value.isEmpty && news.value.count < totalNews {
            currentPage += 1
            service.fetchNews(page: currentPage, count: 10)
        }
    }
    
    func getNewsCount() -> Int {
        news.value.count
    }
    
    func getNews(_ index: Int) -> NewsUIModel {
        news.value[index]
    }
    
    // MARK: - Private methods
    private func binding() {
        service.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.viewState.send(.loading)
                } else {
                    if self.news.value.isEmpty {
                        self.viewState.send(.empty)
                    } else {
                        self.viewState.send(.done)
                    }
                }
            }.store(in: &subscriptions)
        
        service.news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAnswer in
                guard let self else { return }
                oldCount = news.value.count
                var newsUImodel = newAnswer.news.compactMap { NewsUIModel(networkModel: $0) }
                self.totalNews = newAnswer.totalCount
                self.news.value = self.news.value + newsUImodel
                newCount = news.value.count
            }.store(in: &subscriptions)
    }
    
    private func bindingOff() {
        subscriptions.removeAll()
    }
    
}
