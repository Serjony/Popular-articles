//
//  ArticlesViewController.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class MostPopularArticleCell: UITableViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblByLine: UILabel!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblPublishedDate: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageIcon.clipsToBounds = true;
        imageIcon.backgroundColor = .orange
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: Article) {
        lblTitle.text = model.title
        lblByLine.text = model.author
        lblPublishedDate.text = model.publishedDate
        lblSection.text = model.section
        
//        MostPopularArticleService.getImage(object: model) { (image, error) in
//            DispatchQueue.main.async() { () -> Void in
//                self.imageIcon?.image = image
//            }
//        }
    }
}

