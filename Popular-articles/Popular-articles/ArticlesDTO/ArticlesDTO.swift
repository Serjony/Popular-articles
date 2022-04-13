//
//  ArticlesDTO.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 10.04.2022.
//

import Foundation
import UIKit

struct BaseResponse: Decodable {
    var results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Article: Decodable {
    let title: String
    let section: String
    let author: String
    let publishedDate: String
    let url: String
    let image: [Media]
    
    enum CodingKeys: String, CodingKey {
        case title
        case section
        case author = "byline"
        case publishedDate = "published_date"
        case url
        case image = "media"
    }
}

struct Media: Decodable {
    var media: [ImageURL]
    
    enum CodingKeys: String, CodingKey {
        case media = "media-metadata"
    }
}

struct ImageURL: Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
