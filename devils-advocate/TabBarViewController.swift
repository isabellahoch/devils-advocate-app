//
//  TabBarViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 4/26/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Launch") != true {
            print("first launch!")
            defaults.set(true, forKey: "First Launch")
            // important: remove below line after done testing!!
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
            self.navigationController?.performSegue(withIdentifier: "goToPasswordPageNav", sender: nil)
            self.performSegue(withIdentifier: "goToPasswordPage", sender: "tab bar controller")
        }

        self.selectedIndex = 1

        // Do any additional setup after loading the view.
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
