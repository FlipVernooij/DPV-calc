//
//  UIAlertWithSoundController.swift
//  GUE Pocketknife
//
//  Created by flip vernooij on 24/10/2017.
//  Copyright © 2017 flip vernooij. All rights reserved.
//

import UIKit

class UIAlertWithSoundController: UIAlertController{
    
    override func viewWillDisappear(_ animated: Bool) {
        playClick()
        super.viewWillDisappear(animated)
    }
}
