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
    var oldCount: Int { get }
    var newCount: Int { get }
    
    func getNewsCount() -> Int
    func getNews(_ index: Int) -> NewsUIModel
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisAppear()

    func addNews()
}
