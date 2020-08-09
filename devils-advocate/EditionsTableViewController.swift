//
//  EditionsTableViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/26/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditionsTableViewController: UITableViewController {

    var editions : [Edition] = [Edition(title: "2020 Senior Wills", id: "2020-senior-wills", url: "https://devils-advocate.herokuapp.com/2020-senior-wills")]
    
    override func viewDidLoad() {
        getEditions()
        super.viewDidLoad()
    }
    
    func getEditions() {
        Database.database().reference().child("archive").queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String:Any] else {return}

            dictionary.forEach({ (key , value) in

//                print("Key \(key), value \(value) ")
                let dict = value as![String : Any]
                print(dict)
                if (dict["id"] as! String != "2020-senior-wills") {
                    let editionDict = Edition(title:dict["title"] as! String, id:dict["id"] as! String, url:dict["url"] as! String)
                    self.editions.insert(editionDict, at: self.editions.count)
                    self.tableView.reloadData()
                }

            })



        }) { (Error) in

            print("Failed to fetch: ", Error)

        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "editionCell", for: indexPath)
        
        let edition = editions[indexPath.row]
        cell.textLabel?.text = edition.title
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
        let edition = editions[indexPath.row]
        
        if(edition.id=="2020-senior-wills") {
            performSegue(withIdentifier: "EditionTableViewToSeniorWills", sender: edition)
        }
        else {
            performSegue(withIdentifier: "EditionTableViewtoDetail", sender: edition)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let edition = sender as? Edition {
            if(edition.id=="2020-senior-wills") {
                if let completeVC = segue.destination as? SeniorWillsTableViewController {
                    completeVC.selectedEdition = edition
                    completeVC.previousVC = self
                }
            }
            else {
                if let completeVC = segue.destination as? EditionDetailTableViewController {
                    completeVC.selectedEdition = edition
                    completeVC.previousVC = self
                }
            }
        }
    }

}
