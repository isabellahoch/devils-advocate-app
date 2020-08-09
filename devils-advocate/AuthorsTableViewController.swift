//
//  AuthorsTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AuthorsTableViewController: UITableViewController, UISearchResultsUpdating {

    var authors : [Author] = []
    var filteredAuthors : [Author] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        getAuthors()
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        filteredAuthors = authors
        super.viewDidLoad()
    }
    
    func getAuthors() {
        Database.database().reference().child("authors").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String:Any] else {return}

            dictionary.forEach({ (key , value) in

//                print("Key \(key), value \(value) ")
                let dict = value as![String : Any]
                let authorDict = Author(name: dict["name"] as! String, grade: String(dict["class"] as! Int), id: dict["id"] as! String, img: dict["img"] as! String, role: dict["role"] as! String)
                if(!(authorDict.name.lowercased()=="anonymous")) { self.authors.insert(authorDict, at: self.authors.count)
                }
                self.filteredAuthors = self.authors
                self.tableView.reloadData()

            })



        }) { (Error) in

            print("Failed to fetch: ", Error)

        }
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredAuthors = authors.filter { this_author in
                return this_author.name.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredAuthors = authors
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAuthors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath)
        
        let author = filteredAuthors[indexPath.row]
        cell.textLabel?.text = "\(author.name) (\(author.grade))"
        cell.textLabel?.font = UIFont(name: "Baskerville", size: 18.0)

//        let url = URL(string: author.img)
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        cell.imageView?.image = UIImage(data: data!)
        cell.imageView?.image = UIImage(named: author.name)
        
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
        let section = filteredAuthors[indexPath.row]
        
        performSegue(withIdentifier: "AuthorTableViewtoDetail", sender: section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        searchController.isActive = false

        if let completeVC = segue.destination as? AuthorDetailViewController {
            if let author = sender as? Author {
                completeVC.selectedAuthor = author
                completeVC.previousVC = self
            }
        }
    }

}
