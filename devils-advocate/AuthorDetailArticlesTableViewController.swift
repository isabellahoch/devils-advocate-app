//
//  AuthorDetailArticlesTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

//
//  SectionDetailTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AuthorDetailArticlesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var previousVC = AuthorDetailViewController()
    var selectedAuthor : Author?
    var articles : [Article] = []
    var filteredArticles : [Article] = []
    let searchController = UISearchController(searchResultsController: nil)
        
        override func viewDidLoad() {
            getArticles()
            searchController.searchResultsUpdater = self as! UISearchResultsUpdating
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
            filteredArticles = articles
            print(filteredArticles)
            super.viewDidLoad()
        }
        
        func getArticles() {
            Database.database().reference().child("articles").queryOrdered(byChild: "author").queryEqual(toValue:selectedAuthor?.id).observeSingleEvent(of: .value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String:Any] else {return}

                dictionary.forEach({ (key , value) in

    //                print("Key \(key), value \(value) ")
                    let dict = value as![String : Any]
                    let authorDict = self.selectedAuthor
                    let articleDict = Article(title: (dict["title"] as? String)!, tags: ["test","article"], section: dict["section"] as! String, contents: dict["contents"] as! String, author: self.selectedAuthor!, id: dict["id"] as! String, image: "N/A", featured: false, edition: dict["edition"] as! String)
                    self.articles.insert(articleDict, at: self.articles.count)
                    self.filteredArticles = self.articles
                    self.tableView.reloadData()
                    
    //                if let articleDict = Article(json: dict) {
    //                    print(articleDict)
    //                    self.articles.insert(articleDict, at: self.articles.count)
    //                    self.tableView.reloadData()
    //                }

                })



            }) { (Error) in

                print("Failed to fetch: ", Error)

            }
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                filteredArticles = articles.filter { this_article in
                    return this_article.title.lowercased().contains(searchText.lowercased())
                }
                
            } else {
                filteredArticles = articles
            }
            tableView.reloadData()
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredArticles.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionDetailCell", for: indexPath)
            
            let article = filteredArticles[indexPath.row]
            cell.textLabel?.text = article.title
            cell.textLabel?.font = UIFont(name: "Baskerville", size: 18.0)

            
    //        let url = URL(string: article.image)!
    //        let data = try? Data(contentsOf: url)
    //
    //        if let imageData = data {
    //            let image = UIImage(data: imageData)
    //            cell.imageView?.image = image
    //        }

    //        cell.imageView?.image = startup.name
    //            }
    //        }
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // this gives us a single Startup
            let article = filteredArticles[indexPath.row]
            
            performSegue(withIdentifier: "specificAuthorArticlestoDetail", sender: article)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if let completeVC = segue.destination as? ArticleDetailViewController {
                if let article = sender as? Article {
                    completeVC.selectedArticle = article
                    completeVC.previousVC = self
                }
            }
        }

    }
