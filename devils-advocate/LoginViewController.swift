//
//  LoginViewController.swift
//  devils-advocate
//
//  Created by Isabella Hochschild on 8/6/20.
//  Copyright © 2020 Isabella Hochschild. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Student","Alum","Faculty/Staff","Parent/Family","Prospective Student","Other/Multiple Affiliations"]
        // Do any additional setup after loading the view.
    }
    
       override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return pickerData[row]
    }
    
    let defaults = UserDefaults.standard
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        if(passwordInput.text == "sfuhsda") {
            defaults.set(nameInput.text, forKey: "name")
            defaults.set(pickerData[picker.selectedRow(inComponent: 0)], forKey: "affiliation")
            self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
        }
        else {
            let alertController = UIAlertController(title: "Invalid access code.", message: "Please try again (code is case sensitive) or contact UHS administration for the code.", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "OK", style: .default))
                   self.present(alertController, animated: true, completion: nil)
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
