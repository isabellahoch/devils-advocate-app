//
//  ArticlesTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/24/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ArticlesTableViewController: UITableViewController, UISearchResultsUpdating {

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
        super.viewDidLoad()
    }
    
    func getArticles() {
    Database.database().reference().child("articles").queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String:Any] else {return}

            dictionary.forEach({ (key , value) in

//                print("Key \(key), value \(value) ")
                let dict = value as![String : Any]
                let authorDict = self.getAuthor(author_id: dict["author"] as! String)
                let articleDict = Article(title: (dict["title"] as? String)!, tags: ["test","article"], section: dict["section"] as! String, contents: dict["contents"] as! String, author: Author(name: dict["author"] as! String, grade: "?", id: dict["author"] as! String, img: dict["author"] as! String, role: "Contributing Writer"), id: dict["id"] as! String, image: "N/A", featured: false, edition: dict["edition"] as! String)
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
        var authorResult = Author(name: "Anonymous", grade: "none", id: "anonymous", img: "none", role: "Contributing Writer")
        var authorName:String?
        var test_authors: [Author] = []
        
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
            // authorResult = Author(name: name, grade: grade , id: id, img: img, role: role)
            let newAuthor = Author(name: name, grade: grade , id: id, img: img, role: role)
            test_authors.insert(newAuthor, at: test_authors.count)
            print(test_authors)

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        print(test_authors)
        if(test_authors.count>0) {
            return(test_authors[0])
        }
        else {
            return authorResult
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
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
        
        performSegue(withIdentifier: "ArticleTableViewtoDetail", sender: article)
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
