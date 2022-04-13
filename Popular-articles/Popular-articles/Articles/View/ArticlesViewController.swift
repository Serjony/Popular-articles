//
//  ArticlesViewController.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 08.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SafariServices

enum News {
    case mostViewed
    case mostShared
    case mostEmailed
    case favorites
}

final class ArticlesViewController: UIViewController, UITabBarDelegate {
    
    // MARK: - Public properties
    
    let apiService = APIService()
    
    // MARK: - Private properties
    
    private var viewedModel: [Article] = []
    private var sharedModel: [Article] = []
    private var emailedModel: [Article] = []
    private var favoriteModel: [Article] = []

    private let service = APIService()
    private var state: News = .mostViewed
    
    // MARK: - Public properties
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var tabBar: UITabBar!
    @IBOutlet weak private var mostViewed: UITabBarItem!
    @IBOutlet weak private var mostShared: UITabBarItem!
    @IBOutlet weak private var mostEmailed: UITabBarItem!
    @IBOutlet weak private var favorites: UITabBarItem!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        tabBar.selectedItem = mostViewed
        createGestureForTableView()
        setupTableViewSettings()
        getDataForArticles(news: .mostViewed)
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = longPressGestureRecognizer.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            self.showActionSheet(at: indexPath)
        }
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
            state = .mostViewed
            if viewedModel.isEmpty {
                getDataForArticles(news: .mostViewed)
            } else {
                tableView.reloadData()
            }
        } else if item == mostShared {
            state = .mostShared
            if sharedModel.isEmpty {
                getDataForArticles(news: .mostShared)
            } else {
                tableView.reloadData()
            }

        } else if item == mostEmailed {
            state = .mostEmailed
            if emailedModel.isEmpty {
                getDataForArticles(news: .mostEmailed)
            } else {
                tableView.reloadData()
            }
        } else {
            state = .favorites
            if favoriteModel.isEmpty {
                getDataForArticles(news: .favorites)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func createGestureForTableView() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func showActionSheet(at indexPath: IndexPath) {
        if state != .favorites{
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Add to favorite", style: .default, handler: { (_) in
                var model: Article
                switch self.state {
                case .mostViewed:
                    model = self.viewedModel[indexPath.row]
                case .mostShared:
                    model = self.sharedModel[indexPath.row]
                case .mostEmailed:
                    model = self.emailedModel[indexPath.row]
                default:
                    model = self.viewedModel[indexPath.row]
                }
                
                self.favoriteModel.append(model)
            }))
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in }))
            
            present(alertController, animated: true)

        }
        
    }
    
    private func getDataForArticles(news: News) {
        service.sendRequestAndGetData(news: news) { data in
            
            switch data {
            case .success(let articles):
                switch news {
                case .mostViewed:
                    self.viewedModel = articles.results
                case .mostShared:
                    self.sharedModel = articles.results
                case .mostEmailed:
                    self.emailedModel = articles.results
                case .favorites:
                    break
                }
                
                self.tableView.reloadData()
            case .failure(_):
                self.tableView.isHidden = true
                print("No internet connection")
            }
        }
    }
    
    private func openDetail(indexPath: IndexPath) {
        var article: Article
        switch state {
        case .mostViewed:
            article = viewedModel[indexPath.row]
        case .mostShared:
            article = sharedModel[indexPath.row]
        case .mostEmailed:
            article = emailedModel[indexPath.row]
        case .favorites:
            article = favoriteModel[indexPath.row]
        }
        
        //TODO: Create detail VC
        guard let url = URL(string: article.url) else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - View logic

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularArticleCell", for: indexPath) as! MostPopularArticleCell
        
        switch state {
        case .mostViewed:
            cell.configureCell(model: viewedModel[indexPath.row])
        case .mostShared:
            cell.configureCell(model: sharedModel[indexPath.row])
        case .mostEmailed:
            cell.configureCell(model: emailedModel[indexPath.row])
        case .favorites:
            cell.configureCell(model: favoriteModel[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .favorites {
            return favoriteModel.count

        } else {
            return viewedModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetail(indexPath: indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
