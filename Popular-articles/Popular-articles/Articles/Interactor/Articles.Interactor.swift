//
//  Articles.Interactor.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ArticlesInteracting: AnyObject {
    func sendRequestForData()
    func getViewModel() -> [Article]
}

protocol ArticlesInteractorOutput: AnyObject {

    
}

extension Articles {

    final class Interactor {

        // MARK: - Public properties

        weak var output: ArticlesInteractorOutput!

        // MARK: - Private properties

        private let api: ArticlesAPI
        private var entity: Entity!
        private let repository = ArticlesRepository()

        // MARK: - Init

        init(api: ArticlesAPI = APIClient()) {
            self.api = api
        }
    }
}

// MARK: - Business logic

extension Articles.Interactor: ArticlesInteracting {
    func sendRequestForData() {
        repository.sendRequestAndGetData()
    }
    
    func getViewModel() -> [Article] {
        repository.getPopularArticles()
    }
    
}
