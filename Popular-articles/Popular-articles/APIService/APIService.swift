//
//  APIService.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Alamofire

protocol APIServiceProtocol {
    func sendRequestAndGetData(news: News, completionHandler: @escaping (Result<BaseResponse, FetchingError>) -> Void)
}

enum FetchingError: Error {
    case noConnection
}

final class APIService: APIServiceProtocol {
    private let mostViewed = "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=Q36h8xyxtGcLGEwybGCbD9oig6TYXuJO"
    private let mostShared = "https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=Q36h8xyxtGcLGEwybGCbD9oig6TYXuJO"
    private let mostEmailed = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=Q36h8xyxtGcLGEwybGCbD9oig6TYXuJO"

    func sendRequestAndGetData(news: News, completionHandler: @escaping (Result<BaseResponse, FetchingError>) -> Void) {
        var url: URL
        switch news {
        case .mostViewed:
            url = URL(string: mostViewed)!
        case .mostShared:
            url = URL(string: mostShared)!
        case .mostEmailed:
            url = URL(string: mostEmailed)!
        case .favorites:
            url = URL(string: mostViewed)!
        }
        
        if news != .favorites{
            AF.request(url)
                .validate()
                .responseDecodable(of: BaseResponse.self) { (response) in
                    guard let articles = response.value else {
                        return completionHandler(.failure(.noConnection))
                    }
                    completionHandler(.success(articles))
                }
        }
        
    }
}
