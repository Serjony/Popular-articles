//
//  ArticlesViewController.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Kingfisher

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
        if model.image.isEmpty{
            print("Empty")
            imageIcon.image = UIImage(named: "NY")
        } else {
            getImage(data: (model.image[0].media[0].url))

        }
    }
    
    private func getImage(data: String) {
        guard let url = URL(string: data) else { return }
        imageIcon.kf.indicatorType = .activity
        imageIcon.kf.setImage(with: url,
                              placeholder: UIImage(named: "NoPicture"),
                              options: [.transition(.fade(0.5))])
    }
}

