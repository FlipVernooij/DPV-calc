//
//  Extension.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 04/06/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit
import AudioToolbox

extension Dictionary {
    mutating func merge_2(dict: [Key: Value]){
        for (k, v) in dict {
            self[k]=v
        }
    }
}

extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }

    var doubleValue: Double {
        return Double(self.floatValue)
    }
}

extension UIView {
    
    func addBackground(_ imageName: String = "background_1") {
        self.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
    }
    
}

extension UIViewController{
    
    // Set the text values of a UILabel collection
    func setLabelCollection(_ objects: [UILabel], _ value: String) {
        for label in objects {
            label.text = value
        }
    }
    
    func setCustomCollection(_ objects: [UILabel], _ metric_value: String, _ imperial_value: String){
        if(Model.getUserDefaults("properties", "localisation") == Constants.LOCALISATION_METRIC){
            self.setLabelCollection(objects, metric_value)
        } else {
            self.setLabelCollection(objects, imperial_value)
        }
    }
    func setDistanceCollection(_ objects: [UILabel]) {
        self.setCustomCollection(objects, Constants.LABEL_METER, Constants.LABEL_FEET)
    }
    
    func setPressureCollection(_ objects: [UILabel]) {
        self.setCustomCollection(objects, Constants.LABEL_BAR, Constants.LABEL_PSI)
    }

    func setKeyboard(_ field: UITextField) {
        if(Localisation.isMetric()){
            field.keyboardType = UIKeyboardType.numberPad
        }else{
            field.keyboardType = UIKeyboardType.decimalPad
        }
    }
    func setPrecision(_ value: Double, _ as_int: Bool = true) -> String{
        if(as_int){
            return String(Int(round(value)))
        }
        return String(format: "%.2f", value)
    }
    
}

protocol squadClassUtils{
    func playClick()
}

extension squadClassUtils{
    
    func getIphoneXDifference() -> Int{
        let screenSize = UIScreen.main.bounds
        if(screenSize.height == 812.0){
            // this is an iphoneX
            return 35
        }
        return 0
    }
    
    func playClick(){
        AudioServicesPlaySystemSound(Constants.SOUND_CLICK_ID);
    }
}

extension UIViewController: squadClassUtils {}
// These are allready inherited from UIViewController and so the protocol.
//extension UIAlertController: squadClassUtils {}
//extension UITableViewController: squadClassUtils {}


