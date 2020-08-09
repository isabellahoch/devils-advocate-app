//
//  SeniorWillsTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 5/4/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SeniorWillsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var previousVC = EditionsTableViewController()
    var selectedEdition : Edition?
    var wills : [SeniorWill] = []
    var filteredWills : [SeniorWill] = []
    let searchController = UISearchController(searchResultsController: nil)
        
        override func viewDidLoad() {
            getWills()
            searchController.searchResultsUpdater = self as! UISearchResultsUpdating
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
            filteredWills = wills
            print(filteredWills)
            super.viewDidLoad()
        }

        
        func getWills() {
            Database.database().reference().child("archive").child(selectedEdition!.id).child("senior-wills").observeSingleEvent(of: .value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String:Any] else {return}

                dictionary.forEach({ (key , value) in

    //                print("Key \(key), value \(value) ")
                    var dict = value as![String : Any]
                    if (dict["cause_of_death"] == nil) {
                        dict["cause_of_death"] = "?"
                    }
                    if (dict["statement"] == nil) {
                        dict["statement"] = "?"
                    }
                    if (dict["freshmen"] == nil) {
                        dict["freshmen"] = [String:String]()
                    }
                    if (dict["sophomores"] == nil) {
                        dict["sophomores"] = [String:String]()
                    }
                    if (dict["juniors"] == nil) {
                        dict["juniors"] = [String:String]()
                    }
                    if (dict["faculty"] == nil) {
                        dict["faculty"] = [String:String]()
                    }
                    if (dict["miscellaneous"] == nil) {
                        dict["miscellaneous"] = [String:String]()
                    }
                    let seniorWillDict = SeniorWill(will_id: dict["id"] as! String, name: dict["name"] as! String, cause_of_death: dict["cause_of_death"] as! String, statement: dict["statement"] as! String, freshmen: dict["freshmen"] as! [String:String], sophomores: dict["sophomores"] as! [String:String], juniors: dict["juniors"] as! [String:String], faculty: dict["faculty"] as! [String:String], miscellaneous: dict["miscellaneous"] as! [String:String], edition: "2020-senior-wills")
                    self.wills.insert(seniorWillDict, at: self.wills.count)
                    self.filteredWills = self.wills
                    self.tableView.reloadData()

                })



            }) { (Error) in

                print("Failed to fetch: ", Error)

            }
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                filteredWills = wills.filter { this_will in
                    return this_will.name.lowercased().contains(searchText.lowercased())
                }
                
            } else {
                filteredWills = wills
            }
            tableView.reloadData()
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredWills.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "seniorWillCell", for: indexPath)
            
            let will = filteredWills[indexPath.row]
            cell.textLabel?.text = will.name
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
            let will = filteredWills[indexPath.row]
            
            performSegue(withIdentifier: "SeniorWillTableViewtoDetail", sender: will)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            searchController.isActive = false

            if let completeVC = segue.destination as? SeniorWillDetailViewController {
                if let will = sender as? SeniorWill {
                    completeVC.selectedSeniorWill = will
                    completeVC.previousVC = self
                }
            }
        }

    }
