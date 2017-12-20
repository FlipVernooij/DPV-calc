//
// Created by flip vernooij on 16/10/2017.
// Copyright (c) 2017 flip vernooij. All rights reserved.
//

import UIKit

// Model is a simple representation of the UserDefaults setup.
// Currently the data model is based around a bunch of dicts stored in the userDefaults storage.
//
// Current datastructure has a dict<String, Double> reserved for each tab (properties, gasvolumes, transport, and internal (to store authentication related crap))
//
class Model {

    static func syncUserDefaults(){
        Model.resetUserDefaults(merge_with_existing: true)
    }
    // Resets the user-defaults to preset constants.
    // Use reset=false to just append missing values.
    static func resetUserDefaults(merge_with_existing: Bool = false) {

        var gasvolume = [String: Double]()
        var properties = [String: Double]()
        var transport = [String: Double]()
        var diveplan = [String: Double]()
        var internals = [String: Double]()

        // gasvolume
        gasvolume["doubles_cylindersize"] = Constants.GASVOLUME_DOUBLES_CYLINDERSIZE
        gasvolume["doubles_fill_bars"] = Constants.GASVOLUME_DOUBLES_FILL_BARS
        gasvolume["doubles_pennetration_bars"] = Constants.GASVOLUME_DOUBLES_PENNETRATION_BARS
        gasvolume["stages_fill_bars"] = Constants.GASVOLUME_STAGES_FILL_BARS
        gasvolume["stages_pennetration_bars"] = Constants.GASVOLUME_STAGES_PENNETRATION_BARS

        // transport
        transport["dpv_enabled"] = Constants.TRANSPORT_DPV_ENABLED
        transport["dpv_total_burntime"] = Constants.TRANSPORT_DPV_TOTAL_BURNTIME
        transport["dpv_useable_burntime"] = Constants.TRANSPORT_DPV_USEABLE_BURNTIME
        transport["dpv_backup_enabled"] = Constants.TRANSPORT_DPV_BACKUP_ENABLED

        // properties
        properties["scr_swim"] = Constants.PROPERTIES_SCR_SWIM
        properties["scr_swim_stress"] = Constants.PROPERTIES_SCR_SWIM_STRESS
        properties["scr_dpv"] = Constants.PROPERTIES_SCR_DPV
        properties["scr_dpv_stress"] = Constants.PROPERTIES_SCR_DPV_STRESS
        properties["speed_swim"] = Constants.PROPERTIES_SPEED_SWIM
        properties["speed_tow"] = Constants.PROPERTIES_SPEED_TOW
        properties["speed_dpv"] = Constants.PROPERTIES_SPEED_DPV
        properties["localisation"] = Constants.PROPERTIES_LOCALISATION // 1 is metric, 2 is imperial

        diveplan["avg_depth"] = Constants.DIVEPLAN_AVG_DEPTH
        diveplan["stages_amount"] = Constants.DIVEPLAN_STAGES_AMOUNT

        if let activated = self.getUserDefaults("internals", "is_app_activated"){
            internals["is_app_activated"] = activated
        }else {
            internals["is_app_activated"] = 0.0
        }

        if (merge_with_existing == false) {
            var user_values = [String: [String: Double]]()
            user_values["gasvolume"] = gasvolume
            user_values["properties"] = properties
            user_values["transport"] = transport
            user_values["diveplan"] = diveplan
            user_values["internals"] = internals

            self.setUserDefaults(user_values)
            return
        }


        if var app_defaults = self.getUserDefaults(){
            if (app_defaults["gasvolume"] == nil) {
                app_defaults["gasvolume"] = gasvolume
            } else {
                for key in gasvolume.keys {
                    if app_defaults["gasvolume"]?.index(forKey: key) == nil {
                        app_defaults["gasvolume"]?[key] = gasvolume[key]
                    }
                }
            }
            if (app_defaults["transport"] == nil) {
                app_defaults["transport"] = transport
            } else {
                for key in transport.keys {
                    if app_defaults["transport"]?.index(forKey: key) == nil {
                        app_defaults["transport"]?[key] = transport[key]
                    }
                }
            }
            if (app_defaults["properties"] == nil) {
                app_defaults["properties"] = properties
            } else {
                for key in properties.keys {
                    if app_defaults["properties"]?.index(forKey: key) == nil {
                        app_defaults["properties"]?[key] = properties[key]
                    }
                }
            }

            if (app_defaults["diveplan"] == nil) {
                app_defaults["diveplan"] = diveplan
            } else {
                for key in diveplan.keys {
                    if app_defaults["diveplan"]?.index(forKey: key) == nil {
                        app_defaults["diveplan"]?[key] = diveplan[key]
                    }
                }
            }
            if (app_defaults["internals"] == nil) {
                app_defaults["internals"] = internals
            } else {
                for key in internals.keys {
                    if app_defaults["internals"]?.index(forKey: key) == nil {
                        app_defaults["internals"]?[key] = internals[key]
                    }
                }
            }

            self.setUserDefaults(app_defaults)
        } else {
            var user_values = [String: [String: Double]]()
            user_values["gasvolume"] = gasvolume
            user_values["properties"] = properties
            user_values["transport"] = transport
            user_values["diveplan"] = diveplan
            user_values["internals"] = internals
            self.setUserDefaults(user_values)
        }
    }

    static func getCylinderSizeIndex(_ value: Double) -> Int{
        var array = [Double]()
        if(Localisation.isMetric()){
            array = Constants.CYLINDER_VOLUMES_METRIC
        }else{
            array = Constants.CYLINDER_VOLUMES_IMPERIAL
        }
        for (index, array_value) in array.enumerated(){
            if(value == array_value){
                return index
            }
        }
        return 0
    }

    static func getCylinderSizeVolume(_ index: Int) -> Double{
        var array = [Double]()
        if(Localisation.isMetric()){
            array = Constants.CYLINDER_VOLUMES_METRIC
        }else{
            array = Constants.CYLINDER_VOLUMES_IMPERIAL
        }
        if(index >= array.count){
            NSLog("Index is bigger than array count!")
            return 0.0
        }
        return array[index]
    }
    // return all user-defaults for this app
    static func getUserDefaults() -> Dictionary<String, Dictionary<String, Double>>? {
        if let defaults = UserDefaults.standard.dictionary(forKey: "dpv_calc") as? [String: [String: Double]] {
            if (Constants.DEBUG) {
                print("\n  getUserDefaults \n")
                for (key, value) in defaults {
                    print(" \t \(key) = \(value)")
                }
            }
            return defaults
        }
        NSLog("Model->getUserDefaults(): Dict doesn't have key dpv_calc")
        return nil
    }

    // return all user-defaults for a specific tab
    static func getUserDefaults(_ dict: String) -> Dictionary<String, Double>? {
        if let defaults = self.getUserDefaults() {
            if let return_value = defaults[dict] {
                if (Constants.DEBUG) {
                    print("\n  getUserDefaults \n")
                    for (key, value) in return_value {
                        print(" \t \(key) = \(value)")
                    }
                }
                return return_value
            }
            NSLog("Model->getUserDefaults(dict): Dict doesn't have key %@", dict)
            return nil
        }
        return nil
    }

    // Return a specific user-default key
    static func getUserDefaults(_ dict: String, _ key: String) -> Double? {
        if let defaults = self.getUserDefaults(dict) {
            if let return_val = defaults[key] {
                return return_val
            } else {
                NSLog("Model->getUserDefaults(dict): Dict doesn't have key %@ -> %@", dict, key)
            }
        }
        return nil
    }

    // Set all user-defaults for this app
    static func setUserDefaults(_ values: [String: [String: Double]]) {
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(values, forKey: "dpv_calc")
    }

    // Set a user-default key (as in the "properties", "transport", "gasvolume", "internals" dict
    static func setUserDefaults(_ dict: String, _ value: [String: Double]) {
        var user_values = self.getUserDefaults()
        if (user_values == nil) {
            user_values = [String: [String: Double]]()
        }
        user_values![dict] = value
        self.setUserDefaults(user_values!)

    }

    // Set a specific user-defaults key
    static func setUserDefaults(_ dict: String, _ key: String, _ value: Double) {
        var user_values = self.getUserDefaults(dict)
        if (user_values == nil) {
            user_values = [String: Double]()
        }
        user_values![key] = value
        self.setUserDefaults(dict, user_values!)
    }
    
    static func toSigned(_ value: Double) -> Double{
        if(value > 0.0){
            return value
        }
        return 0.0
    }
    
    
    static func calculateDivePlan() -> [String: Double] {
        var diveplan = [String: Double]()
        let from = (Localisation.isMetric() == true ? Constants.LOCALISATION_METRIC : Constants.LOCALISATION_IMPERIAL)
        let userDefaults = Localisation.convertUserDefaults(from, Constants.LOCALISATION_METRIC, false)
        let avg_depth = userDefaults["diveplan"]!["avg_depth"]!
        let stages_amount = userDefaults["diveplan"]!["stages_amount"]!
        //let defaults = Localisation.convertUserDefaults(userDefaults["properties"]!["localisation"]!, Constants.LOCALISATION_METRIC, false)
        if(Constants.DEBUG){
            print("\n  calculate_diveplan -> UserDefaults[pocketknife]: \n")
            for(key, value) in userDefaults{
                print(" \t \(key) = \(value)")
            }
        }
       
        let properties = userDefaults["properties"]
        let transport = userDefaults["transport"]
        let gasvolume = userDefaults["gasvolume"]
        
        let doubles = GasVolume(fill_pressure: Double(gasvolume!["doubles_fill_bars"]!), pennetration_pressure: Double(gasvolume!["doubles_pennetration_bars"]!), volume_size: Double(gasvolume!["doubles_cylindersize"]!*2))
        let stages = GasVolume(fill_pressure: Double(gasvolume!["stages_fill_bars"]!), pennetration_pressure: Double(gasvolume!["stages_pennetration_bars"]!), volume_size: Constants.GASVOLUME_STAGES_CYLINDERSIZE)
        
        let gas_supply = GasSupply(doublesVolume: doubles, stageVolume: stages, stageAmount: Int(stages_amount))
        
        var total_dive_time = 0.0
        var total_trigger_time = 0.0
        var estimated_dpv_pennetration = 0.0
        var estimated_swim_pennetration = 0.0
        var liters_remaining_after_dpv = 0.0
        
        let gasConvert_swim = GasConvert(avg_depth: avg_depth, cylinder_size: doubles.volume_size, scr: Double(properties!["scr_swim"]!), scr_stress: Double(properties!["scr_swim_stress"]!))
        let gasConvert_dpv = GasConvert(avg_depth: avg_depth, cylinder_size: doubles.volume_size, scr: Double(properties!["scr_dpv"]!), scr_stress: Double(properties!["scr_dpv_stress"]!))
        
        diveplan["dpv_backup_enabled"] = 0.0
        diveplan["dpv_stages_reserved"] = 0.0
        if(transport!["dpv_enabled"]! == 1){
            diveplan["dpv_backup_enabled"] = Double(transport!["dpv_backup_enabled"]!)
            if(diveplan["dpv_backup_enabled"] == 0){
                /// amount of stages diveded by 3 <- CEIL is extra stage reserve
                diveplan["dpv_stages_reserved"] = Double(gas_supply.set_stage_reserve(0.33))
            }
            // use 2/3 of [80 percent] of [200 minutes] of total burntime
            let pennetration_triggertime = Double(((transport!["dpv_total_burntime"]! / 100) * transport!["dpv_useable_burntime"]!) / 3)
            let total_possible_triggertime = Double(pennetration_triggertime * 2)
            // Check to see or we have enought gas to forfill the total trigger time...
            
            let total_possible_divetime = Double(gas_supply.get_total_dive_time(avg_depth: avg_depth, scr: Double(properties!["scr_dpv"]!)))
            if(total_possible_divetime > total_possible_triggertime){
                total_trigger_time = total_possible_triggertime
                // calculate remaining dive time
                let liters_used_on_dpv = gasConvert_dpv.minutes2liters(minutes: total_possible_triggertime, is_stressed: false)
                let total_liters = gas_supply.get_total_pennetration_liters() * 2
                liters_remaining_after_dpv = (total_liters - liters_used_on_dpv) / 2
                estimated_swim_pennetration = Double(gasConvert_swim.liters2meters(liters: liters_remaining_after_dpv, speed: Double(properties!["speed_swim"]!), is_stressed: false))
                total_dive_time = total_trigger_time + Double(gasConvert_swim.liters2minutes(liters: liters_remaining_after_dpv*2, is_stressed: false))
            }else{
                total_trigger_time = total_possible_divetime
                total_dive_time = total_possible_divetime
                estimated_swim_pennetration = 0.0
            }
        }else{
            estimated_swim_pennetration = Double(gas_supply.get_total_pennetration_time(avg_depth: avg_depth, scr: Double(properties!["scr_swim"]!)))
            total_dive_time = estimated_swim_pennetration * 2
            estimated_swim_pennetration = Double(gasConvert_swim.minutes2meters(minutes: estimated_swim_pennetration, speed: Double(properties!["speed_swim"]!)))
        }
        
        estimated_dpv_pennetration = Double(gasConvert_dpv.minutes2meters(minutes: (total_trigger_time / 2.0), speed: Double(properties!["speed_dpv"]!)))
        diveplan["gas_total_liters"] = Double(gas_supply.get_total_liters())
        diveplan["gas_pennetration_liters"] = Double(gas_supply.get_total_pennetration_liters())
        diveplan["gas_reserve_liters"] = Double(gas_supply.get_total_liters()) - (gas_supply.get_total_pennetration_liters()*2)
        
        diveplan["total_dive_time"] = total_dive_time
        diveplan["total_pennetration_trigger_time"] = total_trigger_time / 2
        diveplan["total_pennetration_meters"] = estimated_dpv_pennetration + estimated_swim_pennetration
        
        diveplan["estimated_dpv_pennetration"] = estimated_dpv_pennetration
        diveplan["estimated_swim_pennetration"] = estimated_swim_pennetration
        
        
        
        /// We need to figure out how much of the liters in stages is used on dpv (lower scr)
        /// And howmuch when swimming.. higher scr
        
        let dpv_pennetration_time = Double(total_trigger_time / 2)
        let max_dpv_on_stages = gasConvert_dpv.liters2minutes(liters: gas_supply.get_pennetration_liters_in_stages(), is_stressed: false)
        if(dpv_pennetration_time == max_dpv_on_stages){
            diveplan["pennetration_on_stage"] = max_dpv_on_stages
            
            diveplan["pennetration_on_doubles"] = gasConvert_swim.liters2minutes(liters: gas_supply.get_pennetration_liters_in_doubles(), is_stressed: false)
        }else if(dpv_pennetration_time > max_dpv_on_stages){
            diveplan["pennetration_on_stage"] = max_dpv_on_stages
            let minutes_on_dpv_doubles = dpv_pennetration_time - max_dpv_on_stages
            let liters_on_dpv_doubles = gasConvert_dpv.minutes2liters(minutes: minutes_on_dpv_doubles)
            
            let liters_swim_doubles = gas_supply.get_pennetration_liters_in_doubles() - liters_on_dpv_doubles
            
            let minutes_swim_doubles = gasConvert_swim.liters2minutes(liters: liters_swim_doubles, is_stressed: false)
            diveplan["pennetration_on_doubles"] = minutes_swim_doubles + minutes_on_dpv_doubles
        }else{
            diveplan["pennetration_on_doubles"] = gasConvert_swim.liters2minutes(liters: gas_supply.get_pennetration_liters_in_doubles(), is_stressed: false)
            
            let liters_on_dpv = gasConvert_dpv.minutes2liters(minutes: dpv_pennetration_time)
            let liters_on_swim = gas_supply.get_pennetration_liters_in_stages() - liters_on_dpv
            let minutes_on_swim = gasConvert_swim.liters2minutes(liters: liters_on_swim)
            diveplan["pennetration_on_stage"] = dpv_pennetration_time + minutes_on_swim
        }
        
        // Max divetime as in problem ocures at max pennetration, need to return swimming with stress scr.. how long can you swim...
        // Harfd to unittest and not used.. so disable for now.
        /// diveplan["estimated_max_divetime"] = gasConvert_swim.liters2minutes(liters: gas_supply.get_total_remaining_gas(), is_stressed: true)
        diveplan["bars_in_doubles_end_of_dive"] = gasConvert_swim.liters2bars(liters: gas_supply.get_liters_left_in_doubles())
        
        diveplan["reserved_minutes_in_doubles"] = gasConvert_swim.liters2minutes(liters: gas_supply.get_total_reserve_gas(in_doubles_only: true), is_stressed: true)
        diveplan["reserved_minutes_in_stages"] = gasConvert_swim.liters2minutes(liters: gas_supply.get_total_reserve_gas(in_stages_only: true), is_stressed: true)
        diveplan["reserved_minutes_in_total"] = diveplan["reserved_minutes_in_doubles"]! + diveplan["reserved_minutes_in_stages"]!
        
        let liters_swim_part_in_stress = gasConvert_swim.meters2liters(meters: estimated_swim_pennetration, speed: Double(properties!["speed_swim"]!), is_stressed: true)
        let meters_dpv_distance = estimated_dpv_pennetration
        let liters_left_in_stages = gas_supply.get_total_remaining_gas(in_stages_only: true)
        
        
        // all stages
        
        let dpv_trigger = gasConvert_dpv.meters2liters(meters: meters_dpv_distance, speed: Double(properties!["speed_dpv"]!), is_stressed: true)
        let dpv_tow = gasConvert_dpv.meters2liters(meters: meters_dpv_distance, speed: Double(properties!["speed_tow"]!), is_stressed: true)
        let dpv_swim =  gasConvert_swim.meters2liters(meters: meters_dpv_distance, speed: Double(properties!["speed_swim"]!), is_stressed: true)
        
        diveplan["required_in_doubles_when_dpv"] = Model.toSigned(gasConvert_dpv.liters2bars(
            liters: dpv_trigger
                + liters_swim_part_in_stress
                - liters_left_in_stages
        ))
        
        diveplan["required_in_doubles_when_towing"] = Model.toSigned(Double(gasConvert_dpv.liters2bars(
            liters: dpv_tow
                + liters_swim_part_in_stress
                - liters_left_in_stages
        )))
        diveplan["required_in_doubles_when_swimming"] = Model.toSigned(Double(gasConvert_swim.liters2bars(
            liters: dpv_swim
                + liters_swim_part_in_stress
                - liters_left_in_stages
        )))
        
        
        // Half stages
        
        diveplan["required_in_doubles_when_half_stages_and_dpv"] = Model.toSigned(gasConvert_dpv.liters2bars(
            liters: dpv_trigger
                + liters_swim_part_in_stress
                - (liters_left_in_stages / 2))
        )
        
        diveplan["required_in_doubles_when_half_stages_and_tow"] = Model.toSigned(gasConvert_dpv.liters2bars(
            liters: dpv_tow
                + liters_swim_part_in_stress
                - (liters_left_in_stages / 2))
        )
        
        diveplan["required_in_doubles_when_half_stages_and_swim"] = Model.toSigned(gasConvert_swim.liters2bars(
            liters: dpv_swim
                + liters_swim_part_in_stress
                - (liters_left_in_stages / 2))
        )
        
        /// No stages
        
        diveplan["required_in_doubles_when_no_stages_and_dpv"] = Model.toSigned(gasConvert_dpv.liters2bars(
            liters: dpv_trigger
                + liters_swim_part_in_stress
        ))
        
        diveplan["required_in_doubles_when_no_stages_and_tow"] = Model.toSigned(gasConvert_dpv.liters2bars(
            liters: dpv_tow
                + liters_swim_part_in_stress
        ))
        
        diveplan["required_in_doubles_when_no_stages_and_swim"] = Model.toSigned(gasConvert_swim.liters2bars(
            liters: dpv_swim
                + liters_swim_part_in_stress
        ))
        
        if(transport!["dpv_enabled"]! == 0){
            diveplan["required_in_doubles_when_no_stages_and_dpv"] = 0
            diveplan["required_in_doubles_when_no_stages_and_tow"] = 0
            diveplan["required_in_doubles_when_half_stages_and_tow"] = 0
            diveplan["required_in_doubles_when_half_stages_and_dpv"] = 0
            diveplan["required_in_doubles_when_towing"] = 0
            diveplan["required_in_doubles_when_dpv"] = 0
        }
        if(Constants.DEBUG){
            print("\n  calculate_diveplan -> diveplan: \n")
            for(key, value) in diveplan{
                print(" \t \(key) = \(value)")
            }
        }
        return diveplan
    }
    

}
