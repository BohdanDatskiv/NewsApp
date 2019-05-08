//
//  TableViewController.swift
//  News
//
//  Created by Bohdan Datskiv on 5/5/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    var articles = [Article]()
    
    @IBOutlet weak var searchArticle: UISearchBar!
    
    var searchedArticles = [Article]()
    var isSearching = false
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        searchArticle.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedArticles.count
        } else {
            return articles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        cell.isSeenButton.layer.cornerRadius = 10
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
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
            if let date = dateFormatter.date(from: searchedArticles[indexPath.row].publishedAt) {
                dateFormatter.dateFormat = "HH:mm"
                cell.publishedDateLabel.text = dateFormatter.string(from: date)
            }
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
            if let date = dateFormatter.date(from: articles[indexPath.row].publishedAt) {
                dateFormatter.dateFormat = "HH:mm"
                cell.publishedDateLabel.text = dateFormatter.string(from: date)
            }
            if articles[indexPath.row].isSeen {
                cell.isSeenButton.isHidden = true
            } else {
                cell.isSeenButton.isHidden = false
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchData() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=ua&apiKey=7c1c528dec554c0c96485cc9f2a86310"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                let articlesJSON = jsonArray["articles"] as! [[String: Any]]
                DispatchQueue.main.async {
                    self.articles = articlesJSON.compactMap { Article($0) }
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
}

extension TableViewController: arrowButtonTappedDelegate {
    func arrowButtonTapped(for cell: TableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard let url = URL(string: articles[indexPath.row].url) else { return }
        articles[indexPath.row].isSeen = true
        self.tableView.reloadData()
        UIApplication.shared.open(url)
    }
}


extension UISearchBar {
    var cancelButton: UIButton? {
        for subView1 in subviews {
            for subView2 in subView1.subviews {
                if let cancelButton = subView2 as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText == "" {
            searchedArticles = articles
        } else {
            
            searchedArticles = articles.filter({$0.title.lowercased().contains(searchText.lowercased())})
        }
        isSearching = true
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchArticle.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text == "" {
            searchBar.showsCancelButton = false
        }
        searchBar.endEditing(true)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            if let cancelButton = searchBar.cancelButton {
                cancelButton.isEnabled = true
                cancelButton.isUserInteractionEnabled = true
            }
        }
    }
}


