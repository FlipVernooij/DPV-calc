//
//  PropertiesTableViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 05/06/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//


import UIKit

class PropertiesTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var scr_swim: UITextField!
    
    @IBOutlet weak var scr_swim_stress: UITextField!
    
    @IBOutlet weak var scr_dpv: UITextField!
    
    @IBOutlet weak var scr_dpv_stress: UITextField!
    
    @IBOutlet weak var speed_swim: UITextField!
    
    @IBOutlet weak var speed_tow: UITextField!
    
    @IBOutlet weak var speed_dpv: UITextField!
    
    @IBOutlet var volume_labels: [UILabel]!
    
    @IBOutlet var speed_labels: [UILabel]!
    
    @IBOutlet weak var localisation: UISegmentedControl!


    @IBAction func click_disclaimer(_ sender: Any) {
        playClick()
        // create the alert
        let alert = UIAlertWithSoundController(title: Constants.DISCLAIMER_TITLE, message: Constants.DISCLAIMER_TEXT, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: Constants.DISCLAIMER_BUTTON, style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func click_credits(_ sender: Any) {
        playClick()
        // create the alert
        let alert = UIAlertWithSoundController(title: Constants.CREDIT_TITLE, message: Constants.CREDIT_TEXT, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: Constants.CREDIT_BUTTON, style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func change_localisation(_ sender: Any) {
        playClick()
        let new = (sender as! UISegmentedControl).selectedSegmentIndex+1
        if let current = Model.getUserDefaults("properties", "localisation") {
            let defaults = Localisation.convertUserDefaults(current, Double(new))
            self.fillFormValuesFromDefaults(defaults)
            self.setKeyboardType([scr_swim, scr_swim_stress, scr_dpv, scr_dpv_stress])
        }
    }
    
    @IBAction func click_reset(_ sender: Any) {
        playClick()
        // create the alert
        let alert = UIAlertWithSoundController(title: Constants.RESET_TITLE, message: Constants.RESET_TEXT, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: Constants.RESET_BUTTON_CANCEL, style: UIAlertActionStyle.default, handler:nil ))
        alert.addAction(UIAlertAction(title: Constants.RESET_BUTTON_OK, style: UIAlertActionStyle.default, handler: ({ action in
            Model.resetUserDefaults()
            self.fillFormValuesFromDefaults()
        })))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addBackground("background_4")

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        fillFormValuesFromDefaults()
    }

    override func viewWillAppear(_ animated: Bool) {
        playClick()
    }

    override func viewWillDisappear(_ animated: Bool) {
        var properties: [String: Double] = [:]
        if let value = self.scr_swim.text{
            properties["scr_swim"] = value.doubleValue
        }
        if let value = self.scr_swim_stress.text{
            properties["scr_swim_stress"] = value.doubleValue
        }
        if let value = self.scr_dpv.text{
            properties["scr_dpv"] = value.doubleValue
        }
        if let value = self.scr_dpv_stress.text{
            properties["scr_dpv_stress"] = value.doubleValue
        }
        if let value = self.speed_swim.text{
            properties["speed_swim"] = value.doubleValue
        }
        if let value = self.speed_tow.text{
            properties["speed_tow"] = value.doubleValue
        }
        if let value = self.speed_dpv.text{
            properties["speed_dpv"] = value.doubleValue
        }
        properties["localisation"] = Model.getUserDefaults("properties", "localisation")

        Model.setUserDefaults("properties", properties)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Constants.TABLE_HEADER_TEXT_COLOR
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Constants.TABLE_CELL_COLOR
    }


    func fillFormValuesFromDefaults(_ defaults: Dictionary<String, Dictionary<String, Double>>? = nil){
        var data = [String: [String: Double]]()
        if(defaults != nil){
            data = defaults!
        }else{
            data = Model.getUserDefaults()!
        }
        self.setCustomCollection(speed_labels, Constants.LABEL_METERS_PER_MINUTE, Constants.LABEL_FEETS_PER_MINUTE)
        self.setCustomCollection(volume_labels, Constants.LABEL_LITERS_PER_MINUTE, Constants.LABEL_CUFT_PER_MINUTE)

        self.setKeyboard(scr_swim)
        self.setKeyboard(scr_swim_stress)
        self.setKeyboard(scr_dpv)
        self.setKeyboard(scr_dpv_stress)

        let properties = data["properties"]
        if let value = properties?["scr_swim"]{
            self.scr_swim.text = setPrecision(value, Localisation.isMetric())
        }
        if let value = properties?["scr_swim_stress"]{
            self.scr_swim_stress.text = setPrecision(value, Localisation.isMetric())
        }
        if let value = properties?["scr_dpv"]{
            self.scr_dpv.text = setPrecision(value, Localisation.isMetric())
        }
        if let value = properties?["scr_dpv_stress"]{
            self.scr_dpv_stress.text = setPrecision(value, Localisation.isMetric())
        }
        if let value = properties?["speed_swim"]{
            self.speed_swim.text = setPrecision(value)
        }
        if let value = properties?["speed_tow"]{
            self.speed_tow.text = setPrecision(value)
        }
        if let value = properties?["speed_dpv"]{
            self.speed_dpv.text = setPrecision(value)
        }
        // Set localisation
        if let value = properties?["localisation"]{
            self.localisation.selectedSegmentIndex = Int(value-1)
        }
    }

    func setKeyboardType(_ fields: [UITextField]){
        for field in fields {
            if (Localisation.isMetric()) {
                field.keyboardType = Constants.METRIC_KEYBOARD
            } else {
                field.keyboardType = Constants.IMPERIAL_KEYBOARD
            }
        }
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
}
