//
//  ArticlesDTO.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 10.04.2022.
//

import Foundation

struct ArticlesResponse: Codable {
    let popularArticles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let author: String
    let publishedDate: String
    let url: String
    let imageUrl: String
    
}
