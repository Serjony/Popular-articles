//
//  ArticlesRepository.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Foundation

protocol ArticlesRepositoryProtocol {
    func sendRequestAndGetData()
}

final class ArticlesRepository: ArticlesRepositoryProtocol {
    private let service = APIService()
    
    func sendRequestAndGetData() {
        service.sendRequestAndGetData(urlString: "") { data, err in
            for item in data {
                if let item = item as? NSDictionary {
                    print(item.allKeys)
                    //TODO: create model
                }
            }
        }
    }
    
    
}
