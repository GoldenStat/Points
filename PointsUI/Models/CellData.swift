//
//  CellData.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import Foundation

struct CellData: Identifiable {
    var id = UUID()
    var value: Int
    var description: String { value.description }
    var prefix: String { value > 0 ? "+"  : "" } // append a '+' before a positive number
}

func += ( lhs: inout CellData, rhs: CellData) {
    lhs.value += rhs.value
}

func += ( lhs: inout CellData, rhs: Int) {
    lhs.value += rhs
}

func +<Element> (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> where Element: Numeric {
    guard lhs.count == rhs.count else { return lhs }
    var sum : Array<Element> = lhs
    for index in (0 ..< lhs.count) {
        sum[index] += rhs[index]
    }
    return sum
}

prefix func -<Element> (lhs: Array<Element>) -> Array<Element> where Element: FloatingPoint {
    lhs.map { -$0 }
}

func -<Element> (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> where Element: FloatingPoint {
    lhs + -rhs
}

