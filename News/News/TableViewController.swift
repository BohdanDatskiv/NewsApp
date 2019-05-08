//
//  TableViewController.swift
//  News
//
//  Created by Bohdan Datskiv on 5/5/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var cellModel: CellModel!
    @IBOutlet weak var searchArticle: UISearchBar!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        searchArticle.delegate = self
        cellModel.fetchArticles {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel.numberOfRowsInSection(isSearching)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        return cellModel.configure(cell: cell, for: indexPath, isSearching: isSearching)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableViewController: arrowButtonTappedDelegate {
    func arrowButtonTapped(for cell: TableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        cellModel.openUrl(for: indexPath, isSearching: isSearching)
        self.tableView.reloadData()
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
        cellModel.search(text: searchText)
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


