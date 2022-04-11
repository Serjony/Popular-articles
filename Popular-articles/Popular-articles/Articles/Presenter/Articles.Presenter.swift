//
//  Articles.Presenter.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ArticlesPresenting: AnyObject {
    
    func viewDidLoad()
    
}

extension Articles {

    final class Presenter {

        // MARK: - Public properties

        weak var view: ArticlesView!
        var router: ArticlesRouting!
        var interactor: ArticlesInteracting!
    }
}

// MARK: - Presentation logic

extension Articles.Presenter: ArticlesPresenting {
    
    func viewDidLoad() {
        
        interactor.sendRequestForData()

        // router.navigateToSomewhere()
    }

    
}

// MARK: - ArticlesInteractorOutput

extension Articles.Presenter: ArticlesInteractorOutput {

    
}
