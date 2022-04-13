//
//  ArticlesDTO.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 10.04.2022.
//

import Foundation
import UIKit

struct BaseResponse: Decodable {
    var results: [TestArticle]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct TestArticle: Decodable {
    let title: String
    let section: String
    let author: String
    let publishedDate: String
    let url: String
    let image: [ImageURL]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case section
        case author = "byline"
        case publishedDate = "published_date"
        case url
        case image = "media-metadata"
    }
}

struct ImageURL: Decodable {
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

struct Article {
    let title: String
    let section: String
    let author: String
    let publishedDate: String
    let url: String
    let image: UIImage?

}
