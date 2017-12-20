//
//  GasVolume.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 22/04/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

class GasVolume{

    var _volume_size: Double = 0
    var volume_size: Double {
        get {
            return _volume_size
        }
        set {
            _volume_size = newValue
            _total_liters = _volume_size * _fill_pressure
        }
    }
    var _fill_pressure: Double = 0
    var fill_pressure: Double {
        get {
            return _fill_pressure
        }
        set {
            _fill_pressure = newValue
            _total_liters = _volume_size * _fill_pressure
            
        }
    }
    
    var _pennetration_pressure: Double = 0
    var pennetration_pressure: Double {
        get {
            return _pennetration_pressure
        }
        set {
            _pennetration_pressure = newValue
        }
    }

    var _total_liters: Double = 0
    var total_liters: Double {
        get {
            return _total_liters
        }
    }
    
    var pennetration_liters: Double {
        get {
            return pennetration_pressure * volume_size
        }
    }
    
    var reserved_bars: Double {
        get {
            return fill_pressure - (pennetration_pressure * 2)
        }
    }
    
    var reserved_liters: Double {
        get {
            return reserved_bars * volume_size
        }
    }
    
    var remaining_bars: Double {
        get {
            return fill_pressure - pennetration_pressure
        }
    }
    
    var remaining_liters: Double {
        get {
            return remaining_bars * volume_size
        }
    }

    init(fill_pressure: Double, pennetration_pressure: Double, volume_size: Double){
        self.volume_size = volume_size
        self.fill_pressure = fill_pressure
        self.pennetration_pressure = pennetration_pressure
    }
    
    func copy() -> GasVolume {
        let copy = GasVolume(fill_pressure: self.fill_pressure, pennetration_pressure: self.pennetration_pressure, volume_size: self.volume_size)
        return copy
    }
}
