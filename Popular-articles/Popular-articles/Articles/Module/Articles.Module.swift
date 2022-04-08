//
//  Articles.Module.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct Articles {}

extension Articles {
    
    struct Module {
        
        func configure(viewController: ArticlesViewController) {
            
            let router = Router()
            router.viewController = viewController
            
            let presenter = Presenter()
            presenter.view = viewController
            presenter.router = router
            
            let interactor = Interactor()
            interactor.output = presenter
            
            presenter.interactor = interactor
            
            viewController.presenter = presenter
            viewController.interactor = interactor
        }
    }
}
