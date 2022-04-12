//
//  ArticlesLocalAPI.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Foundation

protocol ArticlesLocalAPIProtocol {
    func addArticle(article: Article)
    func getArticles() -> [Article]
}

final class ArticlesLocalAPI: ArticlesLocalAPIProtocol {
    private var popularArticles: [Article] = []

    func addArticle(article: Article) {
        popularArticles.append(article)
    }
    
    func getArticles() -> [Article] {
        return popularArticles
    }
    
}
