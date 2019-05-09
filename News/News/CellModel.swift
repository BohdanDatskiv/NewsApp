//
//  ArticleModel.swift
//  News
//
//  Created by Bohdan Datskiv on 5/8/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation
import UIKit

class CellModel: NSObject {
    @IBOutlet var networkManager: NetworkManager!
    
    private var articles = [Article]()
    private var searchedArticles = [Article]()
    
    func fetchArticles(_ completion: @escaping ()->()) {
        networkManager.fetchArticles { articles in
            self.articles = articles
            completion()
        }
    }
    
    func numberOfRowsInSection(_ isSearching: Bool) -> Int {
        if isSearching {
            return searchedArticles.count
        } else {
            return  articles.count
        }
    }
    
    func configure(cell: TableViewCell, for indexPath: IndexPath, isSearching: Bool) -> TableViewCell {
        cell.isSeenButton.layer.cornerRadius = 10
        if isSearching {
            cell.articleTitleLabel.text = searchedArticles[indexPath.row].title
            cell.articleSourceLabel.text = searchedArticles[indexPath.row].sourceName
            cell.descriptionLabel.text = searchedArticles[indexPath.row].description
            if let image = searchedArticles[indexPath.row].image{
                cell.imageOfArticle.image = image
                cell.imageOfArticle.isHidden = false
                cell.imageTopConstraint.constant = 8
                let ratio = image.size.width / image.size.height
                let newHeight = cell.imageOfArticle.frame.width / ratio
                cell.imageHeight.constant = newHeight
            } else {
                cell.imageOfArticle.isHidden = true
                cell.imageHeight.constant = 0
                cell.imageTopConstraint.constant = 0
            }
            cell.publishedDateLabel.text = searchedArticles[indexPath.row].publishedAt
            if searchedArticles[indexPath.row].isSeen {
                cell.isSeenButton.isHidden = true
            } else {
                cell.isSeenButton.isHidden = false
            }
        } else {
            cell.articleSourceLabel.text = articles[indexPath.row].sourceName
            cell.articleTitleLabel.text = articles[indexPath.row].title
            cell.descriptionLabel.text = articles[indexPath.row].description
            if let image = articles[indexPath.row].image{
                cell.imageOfArticle.image = image
                cell.imageOfArticle.isHidden = false
                cell.imageTopConstraint.constant = 8
                let ratio = image.size.width / image.size.height
                let newHeight = cell.imageOfArticle.frame.width / ratio
                cell.imageHeight.constant = newHeight
            } else {
                cell.imageOfArticle.isHidden = true
                cell.imageHeight.constant = 0
                cell.imageTopConstraint.constant = 0
            }
            cell.publishedDateLabel.text = articles[indexPath.row].publishedAt
            if articles[indexPath.row].isSeen {
                cell.isSeenButton.isHidden = true
            } else {
                cell.isSeenButton.isHidden = false
            }
        }
        return cell
    }
    
    func search(text: String) {
        if text == "" {
            searchedArticles = articles
        } else {
            searchedArticles = articles.filter({$0.title.lowercased().contains(text.lowercased())})
        }
    }
    
    func openUrl(for indexPath: IndexPath, isSearching: Bool){
        if isSearching {
            guard let url = URL(string: searchedArticles[indexPath.row].url) else { return }
            searchedArticles[indexPath.row].isSeen = true
            let index = articles.firstIndex(where: {$0.title == searchedArticles[indexPath.row].title})
            articles[index!].isSeen = true
            UIApplication.shared.open(url)
        } else {
            guard let url = URL(string: articles[indexPath.row].url) else { return }
            articles[indexPath.row].isSeen = true
            UIApplication.shared.open(url)
        }
    }
}
