//
//  DivePlanTableViewController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 20/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit


class DivePlanTableViewController: UITableViewController{

    // Constants
    let SCROLLVIEW_HEIGHT = 700

    
    @IBOutlet var diveplan_tableview: UITableView!
    @IBOutlet weak var diveplan_scrollView: UIScrollView!
    
    // Avarage depth, link spinner to text field.
    @IBOutlet weak var average_label: UILabel!
    @IBOutlet weak var average_depth_field: UITextField!
    @IBOutlet weak var average_depth_stepper: UIStepper!
    
    @IBAction func average_depth_field_edit(_ sender: Any) {
        let value = Int(average_depth_field.text!)
        if  (value != nil) {
            average_depth_stepper.value = Double(value!)
        } else{
            average_depth_field.text = String(Int(average_depth_stepper.value))
        }
        display_diveplan(calculate_diveplan())
        
    }

    @IBAction func average_depth_stepper_action(_ sender: Any) {
        self.average_depth_field.text = String(Int(average_depth_stepper.value))
        self.display_diveplan(calculate_diveplan())
    }
    
    // Stages amount, link spinner to text field.
    @IBOutlet weak var stages_amount_field: UITextField!

    @IBOutlet weak var stages_amount_stepper: UIStepper!
    
    @IBAction func stages_amount_field_editing(_ sender: Any) {
        let value = Int(stages_amount_field.text!)
        if  (value != nil) {
            stages_amount_stepper.value = Double(value!)
        } else{
            stages_amount_field.text = String(Int(stages_amount_stepper.value))
        }
        self.display_diveplan(calculate_diveplan())
    }

    @IBAction func stages_amount_stepper_action(_ sender: Any) {
        stages_amount_field.text = String(Int(stages_amount_stepper.value))
        display_diveplan(calculate_diveplan())
    }
    
    // Text labels bar/psi
    @IBOutlet var pressure_labels: [UILabel]!
    
    // Text labels meter/feet
    @IBOutlet var distance_labels: [UILabel]!

    // Plan data labels.
    @IBOutlet weak var plan_dive_time: UILabel!

    @IBOutlet weak var plan_total_pennetration_trigger_time: UILabel!
    
    @IBOutlet weak var plan_pennetration_time: UILabel!
    
    @IBOutlet weak var plan_penetration_doubles: UILabel!
    
    @IBOutlet weak var plan_penetration_stages: UILabel!
    
    @IBOutlet weak var plan_pennetration_meters: UILabel!
    
    @IBOutlet weak var plan_dpv_pen_meters: UILabel!
    
    @IBOutlet weak var plan_swim_pen_meters: UILabel!
    
    @IBOutlet weak var plan_reserved_total: UILabel!
    
    @IBOutlet weak var plan_reserved_doubles: UILabel!
    
    @IBOutlet weak var plan_reserved_stages: UILabel!
    
    @IBOutlet weak var plan_reserved_dpv: UILabel!
    
    @IBOutlet weak var plan_reserved_dpv_stages: UILabel!
    
    
    @IBOutlet weak var plan_indoubles_dpv: UILabel!
    
    @IBOutlet weak var plan_indoubles_towing: UILabel!
    
    @IBOutlet weak var plan_indoubles_swimming: UILabel!
    
    
    @IBOutlet weak var plan_indoubles_dpv_half_stages: UILabel!
    
    @IBOutlet weak var plan_indoubles_towing_half_stages: UILabel!
    
    @IBOutlet weak var plan_indoubles_swimming_half_stages: UILabel!
    
    
    @IBOutlet weak var plan_indoubles_dpv_nostages: UILabel!
    
    @IBOutlet weak var plan_indoubles_towing_nostages: UILabel!
    
    @IBOutlet weak var plan_indoubles_swimming_nostages: UILabel!


    func set_label_data(_ method : String, _ value : Double, _ label : UILabel, color_red_if : Int = 0, color_orange_if : Int = 0, color_yellow_if : Int = 0){
        var display_value = 0
        if(method == "ceil"){
            display_value = Int(ceil(value))
        }else{
            display_value = Int(floor(value))
        }
        label.text = String(display_value)
        if(color_red_if > 0 && color_red_if <= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_RED
        }else if(color_orange_if > 0 && color_orange_if <= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_ORANGE
        }else if(color_yellow_if > 0 && color_yellow_if <= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_YELLOW
        }else{
            label.textColor = Constants.PLAN_LABEL_COLOR
        }
    }

    func set_label_data_warn_if_lower_than(_ method : String, _ value : Double, _ label : UILabel, color_red_if : Int = 0, color_orange_if : Int = 0, color_yellow_if : Int = 0){
        var display_value = 0
        if(method == "ceil"){
            display_value = Int(ceil(value))
        }else{
            display_value = Int(floor(value))
        }
        label.text = String(display_value)
        if(color_red_if > 0 && color_red_if >= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_RED
        }else if(color_orange_if > 0 && color_orange_if >= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_ORANGE
        }else if(color_yellow_if > 0 && color_yellow_if >= display_value){
            label.textColor = Constants.PLAN_LABEL_COLOR_YELLOW
        }else{
            label.textColor = Constants.PLAN_LABEL_COLOR
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            cell.backgroundColor = Constants.TABLE_CELL_COLOR
            return
        }
         cell.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setDistanceCollection(distance_labels)
        self.setPressureCollection(pressure_labels)
        self.setCustomCollection([average_label], Constants.LABEL_METER_SHORT, Constants.LABEL_FEET_SHORT)
        let avg_depth = Model.getUserDefaults("diveplan", "avg_depth")!
        self.average_depth_field.text = String(Int(avg_depth))
        self.stages_amount_field.text = String(Int(Model.getUserDefaults("diveplan", "stages_amount")!))
    }
    
    override func viewDidLayoutSubviews() {
        display_diveplan(calculate_diveplan())
    }
    
    override func viewDidLoad() {
        Model.syncUserDefaults()
        super.viewDidLoad()
        diveplan_tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0); // margin of the tableView itself.
        
        diveplan_tableview.backgroundColor = UIColor.clear
        diveplan_scrollView.backgroundColor = Constants.TABLE_CELL_COLOR
        self.tableView.addBackground("background_5")
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Set view height..
        let screenSize = UIScreen.main.bounds
        let view_height = screenSize.height - CGFloat(180 + self.getIphoneXDifference())
        diveplan_scrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: view_height)
        // Iphone X fucksup default screen bounds... cause why keep things simple right...
        diveplan_scrollView.contentSize =  CGSize(width: Int(screenSize.width), height: SCROLLVIEW_HEIGHT)
        
        // Make sure that the view moves up when keyboard fades in.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Model.setUserDefaults("diveplan", "avg_depth", Double(self.average_depth_field.text!)!)
        Model.setUserDefaults("diveplan", "stages_amount", Double(self.stages_amount_field.text!)!)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Returns an dict with the given re-calculated diveplan.
    func calculate_diveplan() -> [String: Double]{
        Model.setUserDefaults("diveplan", "avg_depth", average_depth_field.text!.doubleValue)
        Model.setUserDefaults("diveplan", "stages_amount", stages_amount_field.text!.doubleValue)
        return Model.calculateDivePlan()
    }
    
    // displays the calculated diveplan to the screen.
    func display_diveplan(_ calculated_plan: [String: Double]){
        playClick() // play sound everytime the plan changes.
        if(calculated_plan.count == 0){
            return
        }
        
        set_label_data("floor", calculated_plan["total_dive_time"]!, plan_dive_time)
        set_label_data("floor", calculated_plan["total_pennetration_trigger_time"]!, plan_total_pennetration_trigger_time)
        set_label_data("floor", calculated_plan["total_dive_time"]!/2, plan_pennetration_time)
        set_label_data("floor", calculated_plan["pennetration_on_doubles"]!, plan_penetration_doubles)
        set_label_data("floor", calculated_plan["pennetration_on_stage"]!, plan_penetration_stages)
        set_label_data("floor", (calculated_plan["estimated_dpv_pennetration"]! + calculated_plan["estimated_swim_pennetration"]!), plan_pennetration_meters)
        
        set_label_data("floor", calculated_plan["estimated_dpv_pennetration"]!, plan_dpv_pen_meters)
        set_label_data("floor", calculated_plan["estimated_swim_pennetration"]!, plan_swim_pen_meters)

        var lower_than = Int(calculated_plan["total_dive_time"]!/3)+1 // 1 third is correct when not using stages... but it is based on stress scr :(
        if(stages_amount_field.text!.doubleValue > 0.0){
            // now things get complicated...
        }
        lower_than = 0 // disable for now.. to complicated...
        set_label_data_warn_if_lower_than("floor", calculated_plan["reserved_minutes_in_total"]!,  plan_reserved_total, color_red_if: lower_than)
        set_label_data("floor", calculated_plan["reserved_minutes_in_doubles"]!,  plan_reserved_doubles)
        set_label_data("floor", calculated_plan["reserved_minutes_in_stages"]!,  plan_reserved_stages)
        
        set_label_data("ceil", calculated_plan["dpv_stages_reserved"]!, plan_reserved_dpv_stages)
        
        if(calculated_plan["dpv_backup_enabled"]!==1){
            plan_reserved_dpv.text = "Yes"
            plan_reserved_dpv.textColor = Constants.PLAN_LABEL_COLOR
        }else{
            plan_reserved_dpv.text = "No"
            plan_reserved_dpv.textColor = Constants.PLAN_LABEL_COLOR
            if(calculated_plan["estimated_dpv_pennetration"]! > 0 || calculated_plan["dpv_stages_reserved"]! > 0){
                plan_reserved_dpv.textColor = Constants.PLAN_LABEL_COLOR_ORANGE
                plan_reserved_dpv_stages.textColor = Constants.PLAN_LABEL_COLOR_ORANGE
                if(calculated_plan["dpv_stages_reserved"]! == 0){
                    plan_reserved_dpv_stages.textColor = Constants.PLAN_LABEL_COLOR_RED
                    plan_reserved_dpv.textColor = Constants.PLAN_LABEL_COLOR_RED
                }
            }
        }
        
        
        let red = Int(calculated_plan["bars_in_doubles_end_of_dive"]!) // bars_in_doubles_end_of_dive: is after completely emptied the stages.
        let orange = Int(floor(Double(red) * 0.9))
        let yellow = Int(floor(Double(red) * 0.8))
        set_label_data("ceil", calculated_plan["required_in_doubles_when_dpv"]!, plan_indoubles_dpv, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_towing"]!, plan_indoubles_towing, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_swimming"]!,  plan_indoubles_swimming, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)

        set_label_data("ceil", calculated_plan["required_in_doubles_when_half_stages_and_dpv"]!, plan_indoubles_dpv_half_stages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_half_stages_and_tow"]!, plan_indoubles_towing_half_stages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_half_stages_and_swim"]!, plan_indoubles_swimming_half_stages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)

        set_label_data("ceil", calculated_plan["required_in_doubles_when_no_stages_and_dpv"]!, plan_indoubles_dpv_nostages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_no_stages_and_tow"]!, plan_indoubles_towing_nostages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
        set_label_data("ceil", calculated_plan["required_in_doubles_when_no_stages_and_swim"]!, plan_indoubles_swimming_nostages, color_red_if: red, color_orange_if: orange, color_yellow_if: yellow)
    }
}
