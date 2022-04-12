//
//  ArticlesRepository.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Foundation

protocol ArticlesRepositoryProtocol {
    func sendRequestAndGetData()
    func getPopularArticles() -> [Article]
}

final class ArticlesRepository: ArticlesRepositoryProtocol {
    private let service = APIService()
    private let localAPI = ArticlesLocalAPI()
    func sendRequestAndGetData() {
        service.sendRequestAndGetData(urlString: "") { data, err in
            for item in data {
                if let item = item as? NSDictionary {
                    
                    let article = Article(title: item["title"] as? String ?? "",
                                          section: item["section"] as? String ?? "",
                                          author: item["byline"] as? String ?? "",
                                          publishedDate: item["published_date"] as? String ?? "",
                                          url: item["url"] as? String ?? "",
                                          image: nil)


                    self.localAPI.addArticle(article: article)
                }                
            }
        }
    }
    
    func getImageURL(array: NSArray) -> String {
        return ""
    }
    
    func getPopularArticles() -> [Article] {
        return localAPI.getArticles()
    }
    
    
}
