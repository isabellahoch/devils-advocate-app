//
//  AuthorDetailViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/25/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class AuthorDetailViewController: UIViewController {
    
    var previousVC = AuthorsTableViewController()
    var selectedAuthor : Author?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func viewArticlesClicked(_ sender: Any) {
        performSegue(withIdentifier: "authorDetailtoArticles", sender: selectedAuthor)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let completeVC = segue.destination as? AuthorDetailArticlesTableViewController {
            if let author = sender as? Author {
                completeVC.selectedAuthor = author
                completeVC.previousVC = self
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let s = (selectedAuthor?.grade)!
        self.title = (selectedAuthor?.name)!+" '"+String(s[s.index(s.startIndex, offsetBy:2)])+String(s[s.index(s.startIndex, offsetBy:3)])
        name.text = (selectedAuthor?.name)!
        classLabel.text = "Class:    \((selectedAuthor?.grade)!)"
        role.text = "Role:    \((selectedAuthor?.role)!)"
        imageView.image = UIImage(named: selectedAuthor!.name)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
