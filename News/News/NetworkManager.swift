//
//  NetworkManager.swift
//  News
//
//  Created by Bohdan Datskiv on 5/8/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    func fetchArticles(_ completion: @escaping ([Article])->()) {
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
                let articles = articlesJSON.compactMap {Article($0)}
                completion(articles)
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
}
