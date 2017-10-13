//
//  DefaultValues.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 13/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation

public struct DefaultValues {
    // for pins
    let locationUpdateFrequency: TimeInterval = 5 // seconds
    let locationHintFadeTime: TimeInterval = 15 // seconds
    
    // for creating new CLLocation objects to be displayed in mapViews
    // TODO: add altitude and horiz vert accuracy etc
}
