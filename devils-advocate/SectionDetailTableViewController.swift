//
//  SectionDetailTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SectionDetailTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var previousVC : UITableViewController?
    var selectedSection : Section?
    var articles : [Article] = []
    var filteredArticles : [Article] = []
    let searchController = UISearchController(searchResultsController: nil)
        
        override func viewDidLoad() {
            self.title = selectedSection?.name
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
            
            print(selectedSection)
            Database.database().reference().child("articles").queryOrdered(byChild: "section").queryEqual(toValue:selectedSection?.name).observeSingleEvent(of: .value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String:Any] else {return}

                dictionary.forEach({ (key , value) in

    //                print("Key \(key), value \(value) ")
                    let dict = value as![String : Any]
                    let authorDict = Author(name: dict["author"] as! String, grade: "?", id: dict["author"] as! String, img: dict["author"] as! String, role: "Contributing Writer")
                    let articleDict = Article(title: (dict["title"] as? String)!, tags: ["test","article"], section: dict["section"] as! String, contents: dict["contents"] as! String, author: authorDict, id: dict["id"] as! String, image: "N/A", featured: false, edition: dict["edition"] as! String)
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
        
        func getAuthor(author_id:String) -> Author {
            var authorResult:Author?
            var authorName:String?
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("authors").child(author_id).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
                let name = value?["name"] as! String
                let grade = String(value?["class"] as! Int)
                let id = value?["id"] as! String
                let role = "Contributing Writer"
                let img = value?["img"] as! String
                authorResult = Author(name: name, grade: grade , id: id, img: img, role: role)
                authorName = value?["name"] as! String

              // ...
              }) { (error) in
                print(error.localizedDescription)
    //            authorResult = Author(name: "Anonymous", grade: "none", id: "anonymous", img: "none", role: "Contributing Writer")
            }
    //        return authorResult!
            return authorResult ?? Author(name: "Anonymous", grade: "none", id: "anonymous", img: "none", role: "Contributing Writer")
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
            
            performSegue(withIdentifier: "SectionDetailTableViewtoArticleDetail", sender: article)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            searchController.isActive = false

            if let completeVC = segue.destination as? ArticleDetailViewController {
                if let article = sender as? Article {
                    completeVC.selectedArticle = article
                    completeVC.previousVC = self
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Baskerville", size: 17.0)]
    }

    }
