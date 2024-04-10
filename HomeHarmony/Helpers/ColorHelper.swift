//
//  ColorHelper.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/10/24.
//

import SwiftUI

func colorHelper(taskColor: Int) -> Color {
    switch taskColor {
    case 0:
        Color("redColor")
    case 1:
        Color("orangeColor")
    case 2:
        Color("yellowColor")
    case 3:
        Color("greenColor")
    case 4:
        Color("blueColor")
    default:
        Color("secondaryColor")
    }
}
