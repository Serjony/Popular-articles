//
//  ArticlesLocalAPI.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Foundation

final class ArticlesLocalAPI {
    
    private var viewedModel: [ViewModel] = []
    private var sharedModel: [ViewModel] = []
    private var emailedModel: [ViewModel] = []
    private var favoriteModel: [ViewModel] = []
    
    func addArticles(articles: [ViewModel], state: News) {
        switch state {
        case .mostViewed:
            viewedModel = articles
        case .mostShared:
            sharedModel = articles
        case .mostEmailed:
            emailedModel = articles
        case .favorites:
            favoriteModel = articles
        }
    }
    
    func getArticles(state: News) -> [ViewModel] {
        switch state {
        case .mostViewed:
            return viewedModel
        case .mostShared:
            return sharedModel
        case .mostEmailed:
            return emailedModel
        case .favorites:
            return favoriteModel
        }
    }
}
