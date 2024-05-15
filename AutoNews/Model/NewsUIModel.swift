//
//  NewsUIModel.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import Foundation

struct NewsUIModel {
    let id: Int
    let title: String
    let description: String
    let publishedDate: Date
    let url: String
    let fullUrl: String
    let titleImageUrl: URL?
    let categoryType: String
    
    init(id: Int, title: String,
         description: String,
         publishedDate: Date,
         url: String,
         fullUrl: String,
         titleImageUrl: URL?,
         categoryType: String) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.url = url
        self.fullUrl = fullUrl
        self.titleImageUrl = titleImageUrl
        self.categoryType = categoryType
    }
    
    init(networkModel: NewsNetModel) {
        self.id = networkModel.id
        self.title = networkModel.title
        self.description = networkModel.description
        self.publishedDate = Date().createDate(from: networkModel.publishedDate) ?? Date()
        self.url = networkModel.url
        self.fullUrl = networkModel.fullUrl
        if networkModel.titleImageUrl != nil {
            self.titleImageUrl = URL(string:  networkModel.titleImageUrl!)
        } else {
            self.titleImageUrl = nil
        }
        self.categoryType = networkModel.categoryType
    }
    
    /*
    static let example: NewsUIModel = NewsUIModel(id: 8011,
                                                  title: "Mercedes-AMG CLE 53 Cabriolet — новинка с тканевым верхом",
                                                  description: "Незадолго до прихода лета в Северное полушарие Mercedes-AMG представил кабриолет CLE 53 4Matic+",
                                                  publishedDate: Date(),
                                                  url: "avto-novosti/mercedes_cle_cabriolet",
                                                  fullUrl: "https://www.autodoc.ru/avto-novosti/mercedes_cle_cabriolet",
                                                  titleImageUrl: URL(string:"https://file.autodoc.ru/news/avto-novosti/4325548_12.jpg")!,
                                                  categoryType: "Автомобильные новости")
    static let examples: [NewsUIModel] = [NewsUIModel(id: 8011,
                                                      title: "Mercedes-AMG CLE 53 Cabriolet — новинка с тканевым верхом",
                                                      description: "Незадолго до прихода лета в Северное полушарие Mercedes-AMG представил кабриолет CLE 53 4Matic+",
                                                      publishedDate: Date(),
                                                      url: "avto-novosti/mercedes_cle_cabriolet",
                                                      fullUrl: "https://www.autodoc.ru/avto-novosti/mercedes_cle_cabriolet",
                                                      titleImageUrl: URL(string:"https://file.autodoc.ru/news/avto-novosti/4325548_12.jpg")!,
                                                      categoryType: "Автомобильные новости"),
                                          NewsUIModel(id: 8001,
                                                      title: "Гибридный кроссовер Chery с большим запасом хода",
                                                      description: "Компания Chery представила новейшую модель",
                                                      publishedDate: Date(),
                                                      url: "avto-novosti/chery_omoda",
                                                      fullUrl: "https://www.autodoc.ru/avto-novosti/chery_omoda",
                                                      titleImageUrl: URL(string:"https://file.autodoc.ru/news/avto-novosti/1157132644_2.jpg")!,
                                                      categoryType: "Автомобильные новости"),
                                          NewsUIModel(id: 8009,
                                                      title: "Volkswagen California стал роскошнее и просторнее",
                                                      description: "Volkswagen California вернулся и претендует название одного из лучших автодомов на рынке",
                                                      publishedDate: Date(),
                                                      url: "avto-novosti/volkswagen_california",
                                                      fullUrl: "https://www.autodoc.ru/avto-novosti/volkswagen_california",
                                                      titleImageUrl: URL(string:"https://file.autodoc.ru/news/avto-novosti/1681281198_7.jpg")!,
                                                      categoryType: "Автомобильные новости"),
                                          NewsUIModel(id: 8008,
                                                      title: "Открытие магазина в г. Пересвет (Московская область)",
                                                      description: "г. Пересвет, ул. Мира, д.4",
                                                      publishedDate: Date(),
                                                      url: "novosti-kompanii/1940",
                                                      fullUrl: "https://www.autodoc.ru/novosti-kompanii/1940",
                                                      titleImageUrl: nil,
                                                      categoryType: "Новости компании"),
                                          NewsUIModel(id: 8006,
                                                      title: "Nissan выпускает электрический фургон Evalia Townstar",
                                                      description: "Nissan возродил имя Evalia для европейского рынка",
                                                      publishedDate: Date(),
                                                      url: "avto-novosti/nissan_evalia",
                                                      fullUrl: "https://www.autodoc.ru/avto-novosti/nissan_evalia",
                                                      titleImageUrl: URL(string:"https://file.autodoc.ru/news/avto-novosti/1581004161_5.jpg")!,
                                                      categoryType: "Автомобильные новости")]
    */
    
}
