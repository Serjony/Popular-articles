//
//  ArticlesViewController.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ArticlesView: AnyObject {

    
}

final class ArticlesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: ArticlesPresenting!
    var interactor: ArticlesInteracting!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Articles.Module().configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Ask the Presenter to do some work
        
        presenter.viewDidLoad()
        
    }
}

// MARK: - View logic

extension ArticlesViewController: ArticlesView {
    
}
