//
//  DetailNewsViewModelProtocol.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import Foundation

protocol DetailNewsViewModelProtocol: AnyObject {
    
    var model: NewsUIModel { get }
    func openFullNews()
}
