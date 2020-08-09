//
//  ArticleDetailViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/24/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

//
//  StartupDetailViewController.swift
//  1NCUB8
//
//  Created by Isabella Hochschild on 8/8/19.
//  Copyright © 2019 1NCUB8. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ArticleDetailViewController: UIViewController {
    
    var previousVC : UITableViewController?
    var selectedArticle : Article?

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var contents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont(name: "Baskerville", size: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        label.text = selectedArticle!.title
        self.navigationItem.titleView = label
//        self.title = selectedArticle!.title
        articleTitle.text = (selectedArticle?.title)!
        if(selectedArticle?.author.name == selectedArticle?.author.id) {
            var authorResult:Author?
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("authors").child((selectedArticle?.author.id)!).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
                let name = value?["name"] as! String
                let grade = String(value?["class"] as! Int)
                let id = value?["id"] as! String
                let role = "Contributing Writer"
                let img = value?["img"] as! String
                let newAuthor = Author(name: name, grade: grade , id: id, img: img, role: role)
                self.author.text = "by  \((newAuthor.name)) (\((newAuthor.grade)))"

              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        }
        else {
            author.text = "by  \((selectedArticle?.author.name)!) (\((selectedArticle?.author.grade)!))"
        }
        contents.attributedText = selectedArticle?.contents.htmlToAttributedString

        
//        contents.text = selectedArticle?.contents
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        print("buttonTapped")
        
        var authorName = self.author.text!.components(separatedBy: " (")[0]
        authorName.remove(at: authorName.startIndex)
        authorName.remove(at: authorName.startIndex)
        authorName.remove(at: authorName.startIndex)
        
        let textToShare = "\((selectedArticle?.title)!) by \((authorName)) from the Devils' Advocate"
        
        if let myWebsite = NSURL(string: "http://devils-advocate.herokuapp.com/articles/"+selectedArticle!.id) {
               let objectsToShare: [Any] = [textToShare, myWebsite]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
               self.present(activityVC, animated: true, completion: nil)
           }
        
    }

}
