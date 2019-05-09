//
//  News.swift
//  News
//
//  Created by Bohdan Datskiv on 5/5/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation
import UIKit

struct Article {
    var author: String
    var title: String
    var description: String
    var image: UIImage?
    var publishedAt: String
    var url: String
    var isSeen: Bool
    var sourceName: String
    
    init(_ dictionary: [String: Any]) {
        let source = dictionary["source"] as! [String: Any]
        self.sourceName = source["name"] as? String ?? ""
        self.author = dictionary["author"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        if let url = URL(string: dictionary["urlToImage"] as! String) {
            if let data = try? Data(contentsOf: url) {
                self.image = UIImage(data: data)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = dateFormatter.date(from: dictionary["publishedAt"]  as! String) {
            dateFormatter.dateFormat = "HH:mm"
            self.publishedAt = dateFormatter.string(from: date)
        } else {
            self.publishedAt = ""
        }
        self.url = dictionary["url"] as? String ?? ""
        self.isSeen = false
    }
}


