//
//  ItemBackgroundImage.swift
//  KidsDrawing
//
//  Created by HONGYONG SOO on 2017. 10. 11..
//  Copyright © 2017년 com.monts. All rights reserved.
//

import Foundation

let FUNCTION_NONE = 0
let FUNCTION_GALLERY = 1
let FUNCTION_CAMERA = 2
let FUNCTION_WHITE_BACKGROUND = 3
let FUNCTION_BLACK_BACKGROUND = 4

struct ItemBackgroudImage {
    var bServerUrl:Bool = false
    var listFunction:Int = FUNCTION_NONE
    var bNew:Bool = false
    var thumbnailUrl:String = ""
    var backgroundUrl:String = ""
}
