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

struct ViewModel {
    let title: String
    let section: String
    let author: String
    let publishedDate: String
    let url: String
    let imageUrl: String
}

final class ArticlesViewController: UIViewController, UITabBarDelegate {
    
    // MARK: - Private properties

    private var state: News = .mostViewed
    private let service = APIService()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let localAPI = ArticlesLocalAPI()
    
    // MARK: - Public properties
    @IBOutlet weak private var emptyLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var tabBar: UITabBar!
    @IBOutlet weak private var mostViewed: UITabBarItem!
    @IBOutlet weak private var mostShared: UITabBarItem!
    @IBOutlet weak private var mostEmailed: UITabBarItem!
    @IBOutlet weak private var favorites: UITabBarItem!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        tabBar.selectedItem = mostViewed
        emptyLabel.isHidden = true
        createGestureForTableView()
        setupTableViewSettings()
        getDataForArticles(news: .mostViewed)
        getModelsFromLocalEntity()
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = longPressGestureRecognizer.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            self.showActionSheet(at: indexPath)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        emptyLabel.isHidden = true
        tableView.isHidden = false
        if item == mostViewed {
            state = .mostViewed
            if localAPI.getArticles(state: .mostViewed).isEmpty {
                getDataForArticles(news: .mostViewed)
            } else {
                tableView.reloadData()
            }
        } else if item == mostShared {
            state = .mostShared
            if localAPI.getArticles(state: .mostShared).isEmpty {
                getDataForArticles(news: .mostShared)
            } else {
                tableView.reloadData()
            }

        } else if item == mostEmailed {
            state = .mostEmailed
            if localAPI.getArticles(state: .mostEmailed).isEmpty {
                getDataForArticles(news: .mostEmailed)
            } else {
                tableView.reloadData()
            }
        } else {
            state = .favorites
            if localAPI.getArticles(state: .favorites).isEmpty {
                emptyLabel.isHidden = false
                self.emptyLabel.text = "Empty"
                tableView.isHidden = true
            } else {
                getModelsFromLocalEntity()
                tableView.reloadData()
            }
        }
    }
    
    private func setupTableViewSettings() {
        self.tableView.register(UINib(nibName: "MostPopularArticleCell", bundle: nil), forCellReuseIdentifier: "MostPopularArticleCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func createGestureForTableView() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func showActionSheet(at indexPath: IndexPath) {
        if state != .favorites {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Add to favorite", style: .default, handler: { (_) in
                var model: ViewModel
                switch self.state {
                case .mostViewed:
                    model = self.localAPI.getArticles(state: .mostViewed)[indexPath.row]
                case .mostShared:
                    model = self.localAPI.getArticles(state: .mostShared)[indexPath.row]
                case .mostEmailed:
                    model = self.localAPI.getArticles(state: .mostEmailed)[indexPath.row]
                default:
                    model = self.localAPI.getArticles(state: .mostViewed)[indexPath.row]
                }
                
                self.saveToLocalEntity(model: model)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in }))
            
            present(alertController, animated: true)

        }
        
    }
    
    private func getModelsFromLocalEntity() {
        do {
            //TODO: check map error
            var viewModels: [ViewModel] = []
            let entityModels = try context.fetch(ArticleEntity.fetchRequest())
            entityModels.forEach { item in
                let model = ViewModel(title: item.title!,
                                      section: item.section!,
                                      author: item.author!,
                                      publishedDate: item.publishedDate!,
                                      url: item.url!,
                                      imageUrl: item.mediaURL!)
                
                viewModels.append(model)
                localAPI.addArticles(articles: viewModels, state: .favorites)
            }
        } catch {
            print("Entity get error")
        }
    }
    
    private func saveToLocalEntity(model: ViewModel) {
        let localModel = ArticleEntity(context: self.context)
        localModel.title = model.title
        localModel.section = model.section
        localModel.author = model.author
        localModel.publishedDate = model.publishedDate
        localModel.url = model.url
        localModel.mediaURL = model.imageUrl
        
        do {
            try context.save()
        } catch {
            print("Core data save error")
        }
    }
    
    private func getDataForArticles(news: News) {
        service.sendRequestAndGetData(news: news) { data in
            
            switch data {
            case .success(let articles):
                self.emptyLabel.isHidden = true
                self.tableView.isHidden = false
                let viewModel = self.convertArticleToViewModel(article: articles.results)
                switch news {
                case .mostViewed:
                    self.localAPI.addArticles(articles: viewModel, state: .mostViewed)
                case .mostShared:
                    self.localAPI.addArticles(articles: viewModel, state: .mostShared)
                case .mostEmailed:
                    self.localAPI.addArticles(articles: viewModel, state: .mostEmailed)
                case .favorites:
                    break
                }
                
                self.tableView.reloadData()
            case .failure(_):
                self.emptyLabel.isHidden = false
                self.emptyLabel.text = "No connection"
                self.tableView.isHidden = true
                print("No internet connection")
            }
        }
    }
    
    private func convertArticleToViewModel(article: [Article]) -> [ViewModel] {
        var models: [ViewModel] = []
        for item in article {
            let imageUrl: String
            if item.image.isEmpty {
                imageUrl = ""
            } else {
                imageUrl = item.image[0].media[0].url
            }
            let model = ViewModel(title: item.title,
                                  section: item.section,
                                  author: item.author,
                                  publishedDate: item.publishedDate,
                                  url: item.url,
                                  imageUrl: imageUrl)
            models.append(model)
        }
        
        return models
    }
    
    private func openDetail(indexPath: IndexPath) {
        var article: ViewModel
        var url: URL?
        switch state {
        case .mostViewed:
            article = localAPI.getArticles(state: .mostViewed)[indexPath.row]
            url = URL(string: article.url)
        case .mostShared:
            article = localAPI.getArticles(state: .mostShared)[indexPath.row]
            url = URL(string: article.url)
        case .mostEmailed:
            article = localAPI.getArticles(state: .mostEmailed)[indexPath.row]
            url = URL(string: article.url)
        case .favorites:
            article = localAPI.getArticles(state: .favorites)[indexPath.row]
            url = URL(string: article.url)
        }
        
        //TODO: Create detail VC
        guard let url = url else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - TableView

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularArticleCell", for: indexPath) as! MostPopularArticleCell
        
        switch state {
        case .mostViewed:
            cell.configureCell(model: localAPI.getArticles(state: .mostViewed)[indexPath.row])
        case .mostShared:
            cell.configureCell(model: localAPI.getArticles(state: .mostShared)[indexPath.row])
        case .mostEmailed:
            cell.configureCell(model: localAPI.getArticles(state: .mostEmailed)[indexPath.row])
        case .favorites:
            cell.configureCell(model: localAPI.getArticles(state: .favorites)[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .favorites {
            return localAPI.getArticles(state: .favorites).count

        } else {
            return localAPI.getArticles(state: .mostViewed).count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetail(indexPath: indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
