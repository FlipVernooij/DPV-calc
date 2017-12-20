//
//  GasConvert.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 22/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//
import UIKit

class GasConvert{
    var cylinder_size: Double
    var avg_depth: Double
    var scr: Double
    var scr_stress: Double
    
    init(avg_depth: Double, cylinder_size: Double, scr: Double, scr_stress: Double){
        self.cylinder_size = cylinder_size
        self.avg_depth = avg_depth
        self.scr = scr
        self.scr_stress = scr_stress
    }
    
    func _get_liters_per_minute(_ is_stressed: Bool = false) -> Double{
        let avg_depth = Double(self.avg_depth)
        var scr = Double(self.scr)
        if(is_stressed == true){
            scr = Double(self.scr_stress)
        }
        if(scr == 0.0){
            return 1.0
        }
        return scr * ((avg_depth / 10.0) + 1.0)
    }

    func liters2bars(liters: Double) -> Double{
        return liters / self.cylinder_size
    }
    
    func bars2liters(bars: Double) -> Double{
        return bars * self.cylinder_size
    }
    
    func liters2minutes(liters: Double, is_stressed: Bool = false) -> Double{
        return liters / self._get_liters_per_minute(is_stressed)
    }
    
    func minutes2liters(minutes: Double,  is_stressed: Bool = false) -> Double{ 
        return self._get_liters_per_minute(is_stressed) * minutes
    }
    
    func liters2meters(liters: Double, speed: Double,  is_stressed: Bool = false) -> Double{
        let minutes = liters / self._get_liters_per_minute(is_stressed)
        return minutes * speed
    }
    
    func meters2liters(meters: Double, speed: Double, is_stressed: Bool = false) -> Double{
        let minutes = meters / speed
        return minutes * self._get_liters_per_minute(is_stressed)
    }
    
    func minutes2meters(minutes: Double, speed: Double) -> Double{
        return minutes * speed
    }
}
