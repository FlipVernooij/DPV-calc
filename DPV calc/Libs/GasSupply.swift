//
//  GasSupply.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 23/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit

class GasSupply {

    var _doubles: GasVolume
    let _doublesConvert: GasConvert
    
    var _stages: [GasVolume]
    let _stageConvert: GasConvert
    
    var _stage_reserve: Int
    
    init(doublesVolume: GasVolume, stageVolume: GasVolume, stageAmount: Int){
        self._doubles = doublesVolume
        self._doublesConvert = GasConvert(avg_depth: 1, cylinder_size: doublesVolume.volume_size, scr:1, scr_stress: 1)
        self._stageConvert = GasConvert(avg_depth: 1, cylinder_size: stageVolume.volume_size, scr:1, scr_stress: 1)
        var i = 0
        self._stage_reserve = 0
        self._stages = [GasVolume]()
        while(i < stageAmount){
            i=i+1
            self._stages.append(stageVolume.copy())
        }
    }
    
    func set_stage_reserve(_ percentage: Double) -> Int{
        self._stage_reserve = Int(ceil(Double(self._stages.count) * percentage))
        return self._stage_reserve
    }
    
    
    func get_total_liters() -> Double{
        var liters = 0.0
        liters += self._doubles._total_liters
        for stage in self._stages{
            liters += stage._total_liters
        }
        return liters
    }
    
    func get_total_pennetration_liters() -> Double{
        var liters = 0.0
        liters += get_pennetration_liters_in_doubles()
        var i = 0
        for stage in self._stages{
            i += 1
            if(i > self._stage_reserve){
                liters += stage.pennetration_liters
            }
            
        }
        return liters
    }
    
    func get_pennetration_liters_in_doubles() -> Double{
        return self._doubles.pennetration_liters
    }
    
    func get_pennetration_liters_in_stages(_ in_single_stage:Bool=false) -> Double{
        var liters = 0.0
        var i = 0
        for stage in self._stages{
            i += 1
            if(i > self._stage_reserve){
                liters += stage.pennetration_liters
            }
        }
        if(in_single_stage==true){
            if(liters==0.0){
                return 0.0
            }
            return (liters / Double(self._stages.count - self._stage_reserve))
        }
        return liters
    }
    
    func get_total_dive_time(avg_depth: Double, scr: Double) -> Double{
        return self.get_total_pennetration_time(avg_depth:  avg_depth, scr: scr) * 2
    }
    
    func get_total_pennetration_time(avg_depth: Double, scr: Double) -> Double{
        let liters = self.get_total_pennetration_liters()
        let convert = GasConvert(avg_depth: avg_depth, cylinder_size: 24, scr: scr, scr_stress: scr)
        return convert.liters2minutes(liters: liters)
    }
    
    func get_total_remaining_gas(in_doubles_only: Bool=false, in_stages_only: Bool=false) -> Double{
        var liters = 0.0
        if(in_stages_only == false){
            liters += self._doubles.remaining_liters
        }
        if(in_doubles_only == false){
            var i = 0
            for stage in self._stages{
                if(i < self._stage_reserve){
                    liters += stage._total_liters
                }else{
                    liters += stage.remaining_liters
                }
                i += 1
            }
        }
        return liters
    }
    
    func get_total_reserve_gas(in_doubles_only: Bool=false, in_stages_only: Bool=false) -> Double{
        var liters = 0.0
        if(in_stages_only == false){
            liters += self._doubles.reserved_liters
        }
        if(in_doubles_only == false){
            var i = 0
            for stage in self._stages{
                if(i < self._stage_reserve){
                    liters += stage._total_liters
                }else{
                    liters += stage.reserved_liters
                }
                i += 1
            }
        }
        return liters
    }
    
    // Gas left in doubles at the end of the dive.
    func get_liters_left_in_doubles() -> Double{
        var total_pennetration_liters = get_total_pennetration_liters()
        var gas_in_left_doubles = get_total_remaining_gas(in_doubles_only: true)
        // While it is true that on the actual dive you will empty your stages before switching back to the doubles.
        // It is rather confusing to take this into account when displaying the gas left in doubles.
        let total_remaining_in_stages = get_total_remaining_gas(in_stages_only: true)
        if(total_remaining_in_stages >= total_pennetration_liters){
            return gas_in_left_doubles
        }
        total_pennetration_liters -= total_remaining_in_stages
        gas_in_left_doubles -= total_pennetration_liters
        return gas_in_left_doubles
    }
    
}
