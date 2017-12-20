//
//  PasswordViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 01/08/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

//
//  DivePlanTableViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 20/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate{
    
 
    @IBOutlet weak var activation_key: UITextField!
    
    @IBAction func activation_key_edit_start(_ sender: Any) {
        activation_key.textColor = UIColor.black
    }
    
    @IBAction func accept_terms_clicked(_ sender: Any) {
        if(activation_key.text == Constants.ACTIVATION_CODE){
            Model.setUserDefaults("internals", "is_app_activated", 1.0)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController")
            self.present(controller!, animated: true, completion: nil)
        }else{
            self.playClick()
            activation_key.textColor = UIColor.red
        }
    }
    
    
    @IBAction func read_full_disclaimer(_ sender: Any) {
        playClick()
        // create the alert
        let alert = UIAlertWithSoundController(title: Constants.DISCLAIMER_TITLE, message: Constants.DISCLAIMER_TEXT, preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: Constants.DISCLAIMER_BUTTON, style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activation_key.delegate = self

        // Make sure that the view moves up when keyboard fades in.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    // Hide keyboard when touching outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // hide keyboard on "return" key on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activation_key.resignFirstResponder()
        return true
    }
    
    /// When the keyboard comes up,.. the view should be moved up too!
    @objc func keyboardWillShow(notification: NSNotification) {
        playClick()
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

