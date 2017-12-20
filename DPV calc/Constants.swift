//
//  Constants.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 01/08/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//
import UIKit
import AudioToolbox

//  Control calculations:
//
//  210 bars in 12L doubles
//   70 bars useable gas
//   15 meter average depth
//  200 bar in stages
//   80 bars usable gas in stages
//
//  SCR 18, SCR_stress 20
//
//   0 stages =
//

struct Constants {
    static let DEBUG = true
    static let DEBUG_AUTH = false
    static let ACTIVATION_CODE = "ZeroGravity2018"
    static let SOUND_CLICK_ID: SystemSoundID = 1104

    static let PLAN_LABEL_COLOR = UIColor.white
    static let PLAN_LABEL_COLOR_BLACK = UIColor.black
    static let PLAN_LABEL_DISABLED_COLOR = UIColor.gray
    static let PLAN_LABEL_COLOR_RED = UIColor.red
    static let PLAN_LABEL_COLOR_ORANGE = UIColor.orange
    static let PLAN_LABEL_COLOR_YELLOW = UIColor.yellow
    
    static let PLAN_FIELD_DEFAULT = "---"

    static let TABLE_HEADER_HEIGHT = 34
    static let TABLE_HEADER_TEXT_COLOR = UIColor.white
    static let TABLE_ROW_HEIGHT = 44
    static let TABLE_CELL_COLOR =  UIColor(white: CGFloat(0.0), alpha: CGFloat(0.5))
    static let TAB_BAR_HEIGHT = 50
    
    static let FIELD_ENABLED_COLOR = UIColor(white: CGFloat(1.0), alpha: CGFloat(1.0))
    static let FIELD_DISABLED_COLOR = UIColor(white: CGFloat(0.5), alpha: CGFloat(0.5))

    static let LOCALISATION_METRIC = 1.0
    static let LOCALISATION_IMPERIAL = 2.0

    static let METRIC_KEYBOARD = UIKeyboardType.numberPad
    static let IMPERIAL_KEYBOARD = UIKeyboardType.decimalPad

    static let BARS_IN_PSI = 0.0689475728
//    static let LITERS_IN_GALLON = 4.54609
    static let METERS_IN_FEET = 0.3048
    static let LITERS_IN_CUFT_AT_PRESSURE_207B = 0.13679635926  // When at 207 bars  // cufts in liters ... :) 0.035314667
    static let LITERS_IN_CUFT = 28.316846// cufts in liters = 0.035314667

    static let CYLINDER_SIZES_METRIC = ["80Cft", "12L", "15L", "18L", "19L"]
    static let CYLINDER_SIZES_IMPERIAL = ["80Cft", "LP85", "LP95", "18L", "LP120"]
    static let CYLINDER_VOLUMES_METRIC = [Double(80*LITERS_IN_CUFT_AT_PRESSURE_207B), Double(12), Double(15), Double(18), Double(19)]
    static let CYLINDER_VOLUMES_IMPERIAL = [Double(80), Double(12)/LITERS_IN_CUFT_AT_PRESSURE_207B, Double(15)/LITERS_IN_CUFT_AT_PRESSURE_207B, Double(18)/LITERS_IN_CUFT_AT_PRESSURE_207B, Double(19)/LITERS_IN_CUFT_AT_PRESSURE_207B]
    
    static let DISCLAIMER_TITLE = "Disclaimer"
    static let DISCLAIMER_BUTTON = "Accept"
    static let DISCLAIMER_TEXT = "This app only calculates ESTIMATES. Numbers displayed are nothing more than a calculated guess of what you might expect for your dive. \n All calculations are based on the values YOU provide in the various tabs and textfields. Incorrect values set in those textfields have direct consequences for the estimates that are given in the plan view. In NO WAY can you take the given plan for granted, nothing beats your own critical thinking and responsible handling. No one other than YOU can be held responsible for any miscalculations, mistakes or accidents on dives you planned either with or without the help of this application. Usage of this app requires a successfully completed GUE DPV Cave course. This app is not in any way related to GUE. This app can contain bugs, rounding errors and other inconstistencies. The Metric system is used internally for all calculations, switching to the Imperial system only changes the display values NOT internal calculations, minor rounding errors/miscalculations will occur"

    static let CREDIT_TITLE = "Credits"
    static let CREDIT_BUTTON = "Continue"
    static let CREDIT_TEXT = "- Gas rules: Christophe Le Maillot\n - Photography: Alison Perkins \n - App development: Flip Vernooij \n"
    
    static let RESET_TITLE = "Reset defaults"
    static let RESET_BUTTON_OK = "Reset"
    static let RESET_BUTTON_CANCEL = "Cancel"
    static let RESET_TEXT = "When you reset, all numeric values will be reset to their initial defaults."

    static let LABEL_METERS_PER_MINUTE = "mpm."
    static let LABEL_FEETS_PER_MINUTE = "fpm."

    static let LABEL_LITERS_PER_MINUTE = "lpm."
    static let LABEL_CUFT_PER_MINUTE = "cftm."

    static let LABEL_METER = "meter"
    static let LABEL_FEET = "feet"
    static let LABEL_METER_SHORT = "m"
    static let LABEL_FEET_SHORT = "ft"

    static let LABEL_BAR = "bar"
    static let LABEL_PSI = "psi"

    // gasvolume
    static let GASVOLUME_DOUBLES_CYLINDERSIZE = 12.0
    static let GASVOLUME_STAGES_CYLINDERSIZE = Double(80*LITERS_IN_CUFT_AT_PRESSURE_207B)
    static let GASVOLUME_DOUBLES_FILL_BARS = 200.0
    static let GASVOLUME_DOUBLES_PENNETRATION_BARS = 0.0
    static let GASVOLUME_STAGES_FILL_BARS = 200.0
    static let GASVOLUME_STAGES_PENNETRATION_BARS = 80.0

    
    // transport
    static let TRANSPORT_DPV_ENABLED = 0.0
    static let TRANSPORT_DPV_TOTAL_BURNTIME = 100.0
    static let TRANSPORT_DPV_USEABLE_BURNTIME = 80.0
    static let TRANSPORT_DPV_BACKUP_ENABLED = 0.0
    
    // properties
    static let PROPERTIES_SCR_SWIM = 18.0
    static let PROPERTIES_SCR_SWIM_STRESS = 20.0
    static let PROPERTIES_SCR_DPV = 15.0
    static let PROPERTIES_SCR_DPV_STRESS = 19.0
    static let PROPERTIES_SPEED_SWIM = 15.0
    static let PROPERTIES_SPEED_TOW = 30.0
    static let PROPERTIES_SPEED_DPV = 45.0
    static let PROPERTIES_LOCALISATION = Constants.LOCALISATION_METRIC // 1 is metric, 2 is imperial

    // diveplan
    static let DIVEPLAN_AVG_DEPTH = 15.0
    static let DIVEPLAN_STAGES_AMOUNT = 2.0



}


