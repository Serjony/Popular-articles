//
//  Articles.Router.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ArticlesRouting {

    
}

extension Articles {

    final class Router {

        // MARK: - Public properties

        weak var viewController: ArticlesViewController!
    }
}

// MARK: - Navigation

extension Articles.Router: ArticlesRouting {    

}
