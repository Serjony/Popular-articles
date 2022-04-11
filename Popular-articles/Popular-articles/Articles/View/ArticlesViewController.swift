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

final class ArticlesViewController: UIViewController, UITabBarDelegate {
    
    // MARK: - Public properties
    
    var presenter: ArticlesPresenting!
    var interactor: ArticlesInteracting!
    let apiService = APIService()
    
    // MARK: - Public properties
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mostViewed: UITabBarItem!
    @IBOutlet weak var mostShared: UITabBarItem!
    @IBOutlet weak var mostEmailed: UITabBarItem!
    @IBOutlet weak var favorites: UITabBarItem!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Articles.Module().configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        presenter.viewDidLoad()
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == mostViewed {
            print("1")
        } else if item == mostShared {
            print("2")
        } else if item == mostEmailed {
            print("3")
        } else {
            print("4")
        }
    }
}

// MARK: - View logic

extension ArticlesViewController: ArticlesView {
    
}
