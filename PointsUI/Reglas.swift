//
//  ReglasTrucoArgentino.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Reglas {
    private(set) var puntos : Int
    var manos : Int
    var jugadores: Int
    var annotacion: [ Annotation ]
}

enum Annotation {
   case boxes, splitBoxes, matches, table
}
