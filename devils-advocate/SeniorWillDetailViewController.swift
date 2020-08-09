//
//  SeniorWillDetailViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 5/4/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit

class SeniorWillDetailViewController: UIViewController {
    
    var previousVC : UITableViewController?
    var selectedSeniorWill : SeniorWill?
    var willContents : String?

    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedSeniorWill!.name
        testLabel.text = selectedSeniorWill!.name
        willContents = ""
        if(selectedSeniorWill!.cause_of_death != "?") {
            willContents=willContents!+"<br><br><strong>Cause of death</strong>: \(selectedSeniorWill!.cause_of_death)"
        }
        if(selectedSeniorWill!.statement != "?") {
            willContents=willContents!+"<br><br><strong>Statement</strong>: \(selectedSeniorWill!.statement)"
        }
        if(!(selectedSeniorWill!.freshmen.isEmpty)) {
            willContents=willContents!+"<br><br><strong>Freshmen</strong>:"
            for (key,val) in selectedSeniorWill!.freshmen {
                willContents=willContents!+"<br>\(key): \(val)"
            }
        }
        if(!(selectedSeniorWill!.sophomores.isEmpty)) {
            willContents=willContents!+"<br><br><strong>Sophomors</strong>:"
            for (key,val) in selectedSeniorWill!.sophomores {
                willContents=willContents!+"<br>\(key): \(val)"
            }
        }
        if(!(selectedSeniorWill!.juniors.isEmpty)) {
            willContents=willContents!+"<br><br><strong>Juniors</strong>:"
            for (key,val) in selectedSeniorWill!.juniors {
                willContents=willContents!+"<br>\(key): \(val)"
            }
        }
        if(!(selectedSeniorWill!.faculty.isEmpty)) {
            willContents=willContents!+"<br><br><strong>Faculty</strong>:"
            for (key,val) in selectedSeniorWill!.faculty {
                willContents=willContents!+"<br>\(key): \(val)"
            }
        }
        if(!(selectedSeniorWill!.miscellaneous.isEmpty)) {
            willContents=willContents!+"<br><br><strong>Miscellaneous</strong>:"
            for (key,val) in selectedSeniorWill!.miscellaneous {
                willContents=willContents!+"<br>\(key): \(val)"
            }
        }
        contents.attributedText = willContents?.htmlToAttributedString
        let btnShare = UIBarButtonItem(barButtonSystemItem:.action, target: self, action: #selector(btnShare_clicked))
        self.navigationItem.rightBarButtonItem = btnShare
    }
    
    @objc func btnShare_clicked() {
        var seniorName = selectedSeniorWill!.name
        let textToShare = "\(seniorName)'s Senior Will from the Devils' Advocate"
        
        if let myWebsite = NSURL(string: "http://devils-advocate.herokuapp.com/2020-senior-wills/"+selectedSeniorWill!.will_id) {
               let objectsToShare: [Any] = [textToShare, myWebsite]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
            activityVC.popoverPresentationController?.sourceView = self.view
               self.present(activityVC, animated: true, completion: nil)
           }

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
