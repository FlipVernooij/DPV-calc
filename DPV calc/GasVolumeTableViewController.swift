//
//  GasVolumeTableViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 21/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//
import UIKit

class GasVolumeTableViewController: UITableViewController{
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var spacer_cell: UITableViewCell!
    
    @IBOutlet weak var doubles_cylindersize: UISegmentedControl!
    @IBOutlet weak var doubles_fill_bars: UITextField!
    @IBOutlet weak var doubles_pennetration_bars: UITextField!
    
    @IBOutlet weak var stages_fill_bars: UITextField!
    @IBOutlet weak var stages_pennetration_bars: UITextField!
    
    
    @IBOutlet var pressure_labels: [UILabel]!
    
    @IBAction func cylindersize_changed(_ sender: Any) {
        playClick()
    }
    
    @IBAction func doubles_fill_pressure_changed(_ sender: Any) {
        if(Int(doubles_pennetration_bars.text!)! > (Int(doubles_fill_bars.text!)!/3)){
            show_changed_value_warning_doubles(Int(doubles_fill_bars.text!)!/3)
        }
    }
    
    @IBAction func doubles_usable_gas_changed(_ sender: Any) {
        if(Int(doubles_pennetration_bars.text!)! > (Int(doubles_fill_bars.text!)!/3)){
            show_changed_value_warning_doubles(Int(doubles_fill_bars.text!)!/3)
        }
    }
    
    @IBAction func stages_fill_pressure_changed(_ sender: Any) {
        if(Int(stages_pennetration_bars.text!)! > (Int(stages_fill_bars.text!)!/2)){
            show_changed_value_warning_stages(Int(stages_fill_bars.text!)!/2)
        }
    }
    
    @IBAction func stages_usable_gas_changed(_ sender: Any) {
        if(Int(stages_pennetration_bars.text!)! > (Int(stages_fill_bars.text!)!/2)){
            show_changed_value_warning_stages(Int(stages_fill_bars.text!)!/2)
        }
    }


    func show_changed_value_warning_doubles(_ value: Int){
        doubles_pennetration_bars.text = String(value)
//        doubles_pennetration_bars.textColor = Constants.PLAN_LABEL_COLOR_RED
    }

    func show_changed_value_warning_stages(_ value: Int){
        stages_pennetration_bars.text = String(value)
//        stages_pennetration_bars.textColor = Constants.PLAN_LABEL_COLOR_RED
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.stages_pennetration_bars.textColor = Constants.PLAN_LABEL_COLOR_BLACK
//        })
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(section == 0){
            let tableview_content_height = 424
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
        self.tableView.addBackground("background_2")
        // Make sure that the view moves up when keyboard fades in.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

    }

    override func viewWillAppear(_ animated: Bool) {
        playClick()
        // Fill segmented controll from config
        doubles_cylindersize.removeAllSegments()
        var array = Constants.CYLINDER_SIZES_METRIC
        if(Localisation.isMetric()==false){
            array = Constants.CYLINDER_SIZES_IMPERIAL
        }
        for (index, value) in array.enumerated(){
            doubles_cylindersize.insertSegment(withTitle: value, at: index, animated: false)
        }
        self.setPressureCollection(pressure_labels)
        if let gasvolume = Model.getUserDefaults("gasvolume")  {
            if let value = gasvolume["doubles_cylindersize"] {
                self.doubles_cylindersize.selectedSegmentIndex = Model.getCylinderSizeIndex(value)
            }
            if let value = gasvolume["doubles_fill_bars"]{
                self.doubles_fill_bars.text = setPrecision(value)
            }
            if let value = gasvolume["doubles_pennetration_bars"]{
                self.doubles_pennetration_bars.text = setPrecision(value)
            }
            if let value = gasvolume["stages_fill_bars"]{
                self.stages_fill_bars.text = setPrecision(value)
            }
            if let value = gasvolume["stages_pennetration_bars"]{
                self.stages_pennetration_bars.text = setPrecision(value)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        var gas_volume = [String: Double]()
        gas_volume["doubles_cylindersize"] = Model.getCylinderSizeVolume(self.doubles_cylindersize.selectedSegmentIndex)
        if let value = self.doubles_fill_bars.text{
            gas_volume["doubles_fill_bars"] = value.doubleValue
        }
        if let value = self.doubles_pennetration_bars.text{
            gas_volume["doubles_pennetration_bars"] = value.doubleValue
        }
        if let value = self.stages_fill_bars.text{
            gas_volume["stages_fill_bars"] = value.doubleValue
        }
        if let value = self.stages_pennetration_bars.text{
            gas_volume["stages_pennetration_bars"] = value.doubleValue
        }
        gas_volume["stages_cylindersize"] = Constants.GASVOLUME_STAGES_CYLINDERSIZE
        Model.setUserDefaults("gasvolume", gas_volume)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /// When the keyboard comes up,.. the view should be moved up too!
    @objc func keyboardWillShow(notification: NSNotification) {
        playClick()
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - CGFloat(Constants.TAB_BAR_HEIGHT))
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        playClick()
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - CGFloat(Constants.TAB_BAR_HEIGHT))
            }
        }
    }
  
}
