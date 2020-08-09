//
//  SectionsTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SectionsTableViewController: UITableViewController, UISearchResultsUpdating {

    var sections : [Section] = []
    var filteredSections : [Section] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        getSections()
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        filteredSections = sections
        super.viewDidLoad()
    }
    
    func getSections() {
        Database.database().reference().child("sections").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String:Any] else {return}

            dictionary.forEach({ (key , value) in

//                print("Key \(key), value \(value) ")
                let dict = value as![String : Any]
                let sectionDict = Section(name:dict["name"] as! String,id:dict["id"] as! String)
                self.sections.insert(sectionDict, at: self.sections.count)
                self.filteredSections = self.sections
                self.tableView.reloadData()

            })



        }) { (Error) in

            print("Failed to fetch: ", Error)

        }
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredSections = sections.filter { this_section in
                return this_section.name.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredSections = sections
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        
        let section = filteredSections[indexPath.row]
        cell.textLabel?.text = section.name
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
        let section = filteredSections[indexPath.row]
        
        performSegue(withIdentifier: "SectionTableViewtoDetail", sender: section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let completeVC = segue.destination as? SectionDetailTableViewController {
            if let section = sender as? Section {
                completeVC.selectedSection = section
                completeVC.previousVC = self
            }
        }
    }

}
