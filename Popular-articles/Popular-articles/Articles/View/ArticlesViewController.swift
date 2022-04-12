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
    var viewModel: [Article] = []
    
    // MARK: - Public properties
    @IBOutlet weak var tableView: UITableView!
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.getViewModels()
            self.setupTableViewSettings()
        }
        
    }
    
    func getViewModels() {
        self.viewModel = interactor.getViewModel()
    }
    
    func setupTableViewSettings() {
        self.tableView.register(UINib(nibName: "MostPopularArticleCell", bundle: nil), forCellReuseIdentifier: "MostPopularArticleCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
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

extension ArticlesViewController: ArticlesView, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularArticleCell", for: indexPath) as! MostPopularArticleCell
        cell.configureCell(model: viewModel[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedArticle = viewModel.articleForIndex(index: indexPath.row)
//        performSegue(withIdentifier: detailsSegueId, sender: nil)
        
        //взять юрл из модели и открыть сафари
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
