//
//  APIService.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//

import Alamofire

protocol APIServiceProtocol {
    func sendRequestAndGetData(urlString : String, completionHandler: @escaping (NSArray, Error?) -> Void)
}

final class APIService: APIServiceProtocol {
    public let popular = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=Q36h8xyxtGcLGEwybGCbD9oig6TYXuJO"
    
    func sendRequestAndGetData(urlString : String, completionHandler: @escaping (NSArray, Error?) -> Void) {
        NYAlamofireManager.shared.request(popular).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
                guard let dict = json as? NSDictionary else { return }
                if let array = dict["results"] as? NSArray {
                    completionHandler(array, response.error)
                } else { return }
            }
        }
        
    }
}
