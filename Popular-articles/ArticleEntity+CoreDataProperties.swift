//
//  ArticleEntity+CoreDataProperties.swift
//  Popular-articles
//
//  Created by Sergey Balabuts on 14.04.2022.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var section: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var url: String?
    @NSManaged public var mediaURL: String?

}

extension ArticleEntity : Identifiable {

}
