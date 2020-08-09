//
//  SectionsNoSearchTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/26/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

let defaults = UserDefaults.standard

class SectionsNoSearchTableViewController: UITableViewController {

        var sections : [Section] = []
        
        override func viewDidLoad() {
            getSections()
//            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 171, green: 25, blue: 45, alpha: 1.0)]
            if defaults.bool(forKey: "First Launch") != true {
                print("first launch!")
                defaults.set(true, forKey: "First Launch")
                // important: remove below line after done testing!!
                self.performSegue(withIdentifier: "goToPasswordPageFromHome", sender: nil)
            }
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
                    self.tableView.reloadData()

                })



            }) { (Error) in

                print("Failed to fetch: ", Error)

            }
        }

        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
            
            let section = sections[indexPath.row]
            cell.textLabel?.text = section.name
            cell.imageView?.image = UIImage(named: section.id)
            cell.textLabel?.font = UIFont(name: "Baskerville", size: 20.0)
            
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
            let section = sections[indexPath.row]
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
                    nav?.barStyle = UIBarStyle.default
        //            nav?.tintColor = UIColor.white
//                    nav?.tintColor = UIColor(red: 171/255, green: 25/255, blue: 45/255, alpha: 1.0)
                    nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 171/255, green: 25/255, blue: 45/255, alpha: 1.0),NSAttributedString.Key.font:UIFont(name: "Baskerville", size: 25.0)]
    }

    }
