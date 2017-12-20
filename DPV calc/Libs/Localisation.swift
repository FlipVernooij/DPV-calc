//
//  Localisation.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 16/10/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit
class Localisation{

    static func isMetric() -> Bool{
        let current = Model.getUserDefaults("properties", "localisation")
        if(current == Constants.LOCALISATION_METRIC){
            return true
        }
        return false
    }

    static func convertAvgDepth(_ from: Double, _ too: Double, _ avg_depth: Double) -> Double{
        if(from == too){
            return avg_depth
        }
        if(too == Constants.LOCALISATION_METRIC){
            return self.feets2meters(avg_depth)
        }
        return self.meters2feets(avg_depth)
    }
    
    static func convertUserDefaults(_ from: Double, _ too: Double, _ writeToUserDefaults: Bool = true) -> [String: [String: Double]]{
        let defaults = Model.getUserDefaults()
        if(from==too){
            return defaults!
        }
        var user_values = [String:[String:Double]]()
        user_values["properties"] = self.convertProperties(defaults!["properties"]!, too)
        user_values["transport"] = self.convertTransport(defaults!["transport"]!, too)
        user_values["gasvolume"] = self.convertGasvolume(defaults!["gasvolume"]!, too)
        user_values["diveplan"] = self.convertDiveplan(defaults!["diveplan"]!, too)

        user_values["internals"] = defaults!["internals"]
        if(writeToUserDefaults == true){
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(user_values, forKey: "dpv_calc")
        }
        return user_values
    }
    
    // before writing something to the usedefaults, make sure it is all metric!
    static func convertProperties(_ properties: [String:Double], _ too: Double) -> [String:Double]{
        var props = [String: Double]()
        if(too == Constants.LOCALISATION_METRIC){
            props["scr_swim"] = self.cuft2liters(properties["scr_swim"]!)
            props["scr_swim_stress"] = self.cuft2liters(properties["scr_swim_stress"]!)
            props["scr_dpv"] = self.cuft2liters(properties["scr_dpv"]!)
            props["scr_dpv_stress"] = self.cuft2liters(properties["scr_dpv_stress"]!)
            props["speed_swim"] = self.feets2meters(properties["speed_swim"]!)
            props["speed_tow"] = self.feets2meters(properties["speed_tow"]!)
            props["speed_dpv"] = self.feets2meters(properties["speed_dpv"]!)
        }else{
            props["scr_swim"] = self.liters2cuft(properties["scr_swim"]!)
            props["scr_swim_stress"] = self.liters2cuft(properties["scr_swim_stress"]!)
            props["scr_dpv"] = self.liters2cuft(properties["scr_dpv"]!)
            props["scr_dpv_stress"] = self.liters2cuft(properties["scr_dpv_stress"]!)
            props["speed_swim"] = self.meters2feets(properties["speed_swim"]!)
            props["speed_tow"] = self.meters2feets(properties["speed_tow"]!)
            props["speed_dpv"] = self.meters2feets(properties["speed_dpv"]!)
        }
        props["localisation"] = too
        return props
    }

    // before writing something to the usedefaults, make sure it is all metric!
    static func convertGasvolume(_ gasvolume: [String:Double], _ too: Double) -> [String:Double]{
        var props = [String: Double]()
        if(too == Constants.LOCALISATION_METRIC){
            props["doubles_cylindersize"] = gasvolume["doubles_cylindersize"]
            /// When switching from metric to imerial a couple of times, the bars are changing becuase of rounding errors.
            /// By making it an integer everytime this problem should be minimized.
            props["doubles_fill_bars"] = Double(Int(self.psi2bars(gasvolume["doubles_fill_bars"]!)))
            props["doubles_pennetration_bars"] = Double(Int(self.psi2bars(gasvolume["doubles_pennetration_bars"]!)))
            props["stages_fill_bars"] = Double(Int(self.psi2bars(gasvolume["stages_fill_bars"]!)))
            props["stages_pennetration_bars"] = Double(Int(self.psi2bars(gasvolume["stages_pennetration_bars"]!)))
        }else{
            props["doubles_cylindersize"] = gasvolume["doubles_cylindersize"]
            props["doubles_fill_bars"] = self.bars2psi(gasvolume["doubles_fill_bars"]!)
            props["doubles_pennetration_bars"] = self.bars2psi(gasvolume["doubles_pennetration_bars"]!)
            props["stages_fill_bars"] = self.bars2psi(gasvolume["stages_fill_bars"]!)
            props["stages_pennetration_bars"] = self.bars2psi(gasvolume["stages_pennetration_bars"]!)
        }
        return props
    }

    static func convertDiveplan(_ diveplan: [String: Double], _ too: Double) -> [String: Double]{
        var props = [String: Double]()
        props["stages_amount"] = diveplan["stages_amount"]
        if(too == Constants.LOCALISATION_METRIC){
            props["avg_depth"] = self.feets2meters(diveplan["avg_depth"]!)
        }else{
            props["avg_depth"] = self.meters2feets(diveplan["avg_depth"]!)
        }
        return props
    }
    
    static func convertTransport(_ transport: [String:Double], _ too: Double) -> [String:Double]{
        var props = [String: Double]()
        props["dpv_enabled"] = transport["dpv_enabled"]
        props["dpv_total_burntime"] = transport["dpv_total_burntime"]
        props["dpv_useable_burntime"] = transport["dpv_useable_burntime"]
        props["dpv_backup_enabled"] = transport["dpv_backup_enabled"]
        return props
    }

    static func liters2cuft(_ liters: Double) -> Double{

        return liters / Constants.LITERS_IN_CUFT
    }
    
    static func cuft2liters(_ cuft: Double) -> Double{
        return cuft * Constants.LITERS_IN_CUFT
    }
    
    static func meters2feets(_ meters: Double) -> Double{
        return meters / Constants.METERS_IN_FEET
    }
    
    static func feets2meters(_ feets: Double) -> Double{
        return feets * Constants.METERS_IN_FEET
    }
    
    static func bars2psi(_ bars: Double) -> Double{
        return bars / Constants.BARS_IN_PSI
    }
    
    static func psi2bars(_ psi: Double) -> Double{
        return psi * Constants.BARS_IN_PSI
    }

}
