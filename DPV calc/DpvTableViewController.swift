//
//  PropertiesTableViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 05/06/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//


import UIKit

class DpvTableViewController: UITableViewController {
    
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var dpv_enabled: UISwitch!
    
    @IBOutlet weak var dpv_backup_enabled: UISwitch!
    
    @IBOutlet weak var dpv_total_burntime: UITextField!
    
    @IBOutlet weak var dpv_useable_burntime: UITextField!
    
    @IBAction func dpv_enabled_changed(_ sender: Any) {
        playClick()
        let bg_queue = DispatchQueue.global()
        if self.dpv_enabled.isOn{
            bg_queue.async(execute: {
                // your network request here...
                self.dpv_useable_burntime.backgroundColor = Constants.FIELD_ENABLED_COLOR
                DispatchQueue.main.async(execute: {
                    self.dpv_backup_enabled.isEnabled = true
                    self.enableField(self.dpv_total_burntime)
                    self.enableField(self.dpv_useable_burntime)
                })
            })
        }else{
            bg_queue.async(execute: {
                // your network request here...
                DispatchQueue.main.async(execute: {
                    self.dpv_backup_enabled.isEnabled = false
                    self.disableField(self.dpv_total_burntime)
                    self.disableField(self.dpv_useable_burntime)
                    
                })
            })
        }

    }
    
    @IBAction func backup_dpv_changed(_ sender: Any) {
        playClick()
    }
    
    func disableField(_ field: UITextField){
        field.isEnabled = false
        field.backgroundColor = Constants.FIELD_DISABLED_COLOR
    }
    
    func enableField(_ field: UITextField){
        field.isEnabled = true
        field.backgroundColor = Constants.FIELD_ENABLED_COLOR
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(section == 0){
            let tableview_content_height = 290
            let screenSize = UIScreen.main.bounds
            let push_down = screenSize.height - CGFloat(tableview_content_height + self.getIphoneXDifference())
            
            return  CGFloat(push_down)
        }
        return  CGFloat(Constants.TABLE_HEADER_HEIGHT)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Constants.TABLE_HEADER_TEXT_COLOR
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Constants.TABLE_CELL_COLOR
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addBackground("background_3")
        
        //Looks for single or multiple taps.
        let edit_end_tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        edit_end_tap.cancelsTouchesInView = false
        view.addGestureRecognizer(edit_end_tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.tableView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playClick()
        if let transport = Model.getUserDefaults("transport"){
            self.dpv_total_burntime.text = String(Int(transport["dpv_total_burntime"]!))
            self.dpv_useable_burntime.text = String(Int(transport["dpv_useable_burntime"]!))

            if transport["dpv_enabled"] == 1.0{
                self.dpv_enabled.setOn(true, animated: false)
                self.enableField(self.dpv_total_burntime)
                self.enableField(self.dpv_useable_burntime)
                self.dpv_backup_enabled.isEnabled = true
            }else{
                self.dpv_enabled.setOn(false, animated: false)
                self.disableField(self.dpv_total_burntime)
                self.disableField(self.dpv_useable_burntime)
                self.dpv_backup_enabled.isEnabled = false
            }

            if(transport["dpv_backup_enabled"] == 1.0){
                self.dpv_backup_enabled.setOn(true, animated: false)
            }else{
                self.dpv_backup_enabled.setOn(false, animated: false)
            }
        }
    }
    
    // ViewWillApear on the new view is called before this method is called :(
override func viewWillDisappear(_ animated: Bool) {
        var transport: [String: Double] = [:]
        
        if let value = self.dpv_total_burntime.text{
            transport["dpv_total_burntime"] = value.doubleValue
        }else{
            transport["dpv_total_burntime"] = Constants.TRANSPORT_DPV_TOTAL_BURNTIME
        }
        if let value = self.dpv_useable_burntime.text{
            transport["dpv_useable_burntime"] = value.doubleValue
        }else{
            transport["dpv_useable_burntime"] = Constants.TRANSPORT_DPV_USEABLE_BURNTIME
        }
        
        if(self.dpv_enabled.isOn){
            transport["dpv_enabled"] = 1
        }else{
            transport["dpv_enabled"] = 0
        }

        if(self.dpv_backup_enabled.isOn){
            transport["dpv_backup_enabled"] = 1
        }else{
            transport["dpv_backup_enabled"] = 0
        }

        Model.setUserDefaults("transport", transport)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
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
